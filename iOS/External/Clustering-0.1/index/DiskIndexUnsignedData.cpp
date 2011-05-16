/*							-*- C++ -*-
** DiskIndexUnsignedData.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 16:42:21 2006 Julien Lemoine
** $Id$
** 
** Copyright (C) 2006 Julien Lemoine
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU Lesser General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
** 
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU Lesser General Public License for more details.
** 
** You should have received a copy of the GNU Lesser General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#include "DiskIndexUnsignedData.h"
#include <assert.h>
#include "Exception.h"
#include "ports.h"
#include "IndexUnsignedIterator.h"

Index::DiskIndexUnsignedData::diskEntry::diskEntry(unsigned nb, off_t position) :
  nbElements(nb), filePosition(position)
{
}

Index::DiskIndexUnsignedData::DiskIndexUnsignedData(const std::string &filename) :
  IndexUnsignedData(), _fd(0x0), _filename(filename), _indexFd(0x0), _cnt(0)
{
  _fd = fopen(filename.c_str(), "w+b");
  if (!_fd)
    throw ToolBox::Exception("Could not open : " + filename, HERE);
  pthread_mutex_init(&_fileMutex, 0x0);
  _indexFilename = filename + std::string(".off");
  _indexFd = fopen(_indexFilename.c_str(), "w+b");
  if (!_indexFd)
    throw ToolBox::Exception("Could not open : " + _indexFilename, HERE);
}

Index::DiskIndexUnsignedData::~DiskIndexUnsignedData()
{
  pthread_mutex_destroy(&_fileMutex);
  close();
}

unsigned Index::DiskIndexUnsignedData::addElement()
{
  assert(_fd);
  assert(_indexFd);

  pthread_mutex_lock(&_fileMutex);
  if (fseeko(_indexFd, 0, SEEK_END) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  diskEntry en(0, ftello(_fd));
  if (fwrite(&en, sizeof(diskEntry), 1, _indexFd) != 1)
    throw ToolBox::Exception("Invalid write to file", HERE);
  pthread_mutex_unlock(&_fileMutex);
  ++_cnt;
  return _cnt - 1;
}

void Index::DiskIndexUnsignedData::addElements(unsigned nbElements)
{
  assert(_fd);
  assert(_indexFd);

  pthread_mutex_lock(&_fileMutex);
  if (fseeko(_indexFd, 0, SEEK_END) != 0)
    throw ToolBox::Exception("file seek error", HERE);

  diskEntry en(0, ftello(_fd));
  for (unsigned int i = 0; i < nbElements; ++i)
    {
      if (fwrite(&en, sizeof(diskEntry), 1, _indexFd) != 1)
	throw ToolBox::Exception("Invalid write to file", HERE);
      ++_cnt;
    }
  pthread_mutex_unlock(&_fileMutex);
}

void Index::DiskIndexUnsignedData::addEntryCurrentElement(unsigned id)
{
  assert(_fd);
  assert(_indexFd);

  // increass number of entry for id
  diskEntry en = _getEntry(_cnt - 1);
  ++en.nbElements;
  _setEntry(_cnt - 1, en);

  // assume that file position is correct, we are filling
  if (fwrite(&id, sizeof(unsigned), 1, _fd) != 1)
    throw ToolBox::Exception("Invalid write to file", HERE);
}

void Index::DiskIndexUnsignedData::close()
{
  if (_fd)
    {
      fclose(_fd);
      ToolBox::unlink(_filename.c_str());
    }
  if (_indexFd)
    {
      fclose(_indexFd);
      ToolBox::unlink(_indexFilename.c_str());
    }
  _fd = 0;
  _indexFd = 0;
}

void Index::DiskIndexUnsignedData::incFrequency(unsigned id, unsigned val)
{
  diskEntry en = _getEntry(id);
  en.nbElements += val;
  _setEntry(id, en);
}

unsigned Index::DiskIndexUnsignedData::getNbElements() const
{
  return _cnt;
}

unsigned Index::DiskIndexUnsignedData::getNbEntries(unsigned id) const
{
  diskEntry en = _getEntry(id);
  return en.nbElements;
}

Index::IndexUnsignedIterator Index::DiskIndexUnsignedData::_getElement(unsigned id, 
								       unsigned* &cache, 
								       unsigned &cacheSize) const

{
  assert(_fd);
  assert(_indexFd);

  if (id >= getNbElements())
    throw ToolBox::Exception("Invalid index", HERE);

  // Warning, this method can be used in multi-threaded mode, it must
  // be protected by a mutex

  const diskEntry entry = _getEntry(id);
  if (cacheSize < entry.nbElements)
    {
      delete[] cache;
      cache = new unsigned[entry.nbElements + 1];
      cacheSize = entry.nbElements + 1;
    }
  pthread_mutex_lock(&_fileMutex);
  if (fseeko(_fd, entry.filePosition, SEEK_SET) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  if (fread(cache, sizeof(unsigned), entry.nbElements, _fd) != entry.nbElements)
    throw ToolBox::Exception("Invalid read", HERE);
  pthread_mutex_unlock(&_fileMutex);
  return IndexUnsignedIterator(cache, cache + entry.nbElements, entry.nbElements);
}

void Index::DiskIndexUnsignedData::_initRandomFill()
{
  // this method can not be multi-threaded
  assert(_fd);
  assert(_indexFd);

  unsigned int i, buffSize = 32768;

  // Fill position in _getMemIndex
  off_t pos = 0;
  diskEntry en(0, 0);
  for (i = 0; i < getNbElements(); ++i)
    {
      en = _getEntry(i);
      en.filePosition = pos;
      pos += en.nbElements * sizeof(unsigned);
      _setEntry(i, en);
    }
  // Fill the whole content of file with random content to avoid the
  // kernel to fragment a lot the file
  if (fseeko(_fd, 0, SEEK_SET) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  char *dest = new char[buffSize];
  // Initialize buffer with x to avoid valgrind error :
  // points to uninitialised bytes
  for (i = 0; i < buffSize; ++i)
    dest[i] = 'x';
  while (pos > 0)
    pos -= fwrite(dest, 1, buffSize, _fd);
  delete[] dest;
}

void Index::DiskIndexUnsignedData::_setRandomVal(unsigned i, unsigned j, unsigned val)
{
  // this method can not be multi-threaded
  assert(_fd);
  assert(_indexFd);

  if (i >= getNbElements())
    throw ToolBox::Exception("Invalid id", HERE);

  const diskEntry en = _getEntry(i);
  if (fseeko(_fd, en.filePosition + (sizeof(unsigned) * j), SEEK_SET) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  if (fwrite(&val, sizeof(unsigned), 1, _fd) != 1)
    throw ToolBox::Exception("Invalid write to file", HERE);
}

Index::DiskIndexUnsignedData::diskEntry Index::DiskIndexUnsignedData::_getEntry(unsigned id) const
{
  assert(_fd);
  assert(_indexFd);

  pthread_mutex_lock(&_fileMutex);
  if (fseeko(_indexFd, (off_t)sizeof(diskEntry) * (off_t)id, SEEK_SET) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  diskEntry en(0, 0);
  if (fread(&en, sizeof(diskEntry), 1, _indexFd) != 1)
    throw ToolBox::Exception("file read error", HERE);
  pthread_mutex_unlock(&_fileMutex);
  return en;
}

void Index::DiskIndexUnsignedData::_setEntry(unsigned id, const diskEntry &en)
{
  assert(_fd);
  assert(_indexFd);

  pthread_mutex_lock(&_fileMutex);
  if (fseeko(_indexFd, (off_t)sizeof(diskEntry) * (off_t)id, SEEK_SET) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  if (fwrite(&en, sizeof(diskEntry), 1, _indexFd) != 1)
    throw ToolBox::Exception("file write error", HERE);
  pthread_mutex_unlock(&_fileMutex);
}
