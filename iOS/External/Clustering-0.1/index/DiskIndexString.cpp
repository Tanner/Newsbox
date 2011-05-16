/*
** DiskIndexString.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 18:53:21 2006 Julien Lemoine
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

#include "DiskIndexString.h"
#include <assert.h>
#include "Exception.h"
#include "ports.h"

Index::DiskIndexString::diskEntry::diskEntry(unsigned nb, off_t pos) :
  nbChars(nb), position(pos)
{
}

Index::DiskIndexString::DiskIndexString(const std::string &filename) :
  Index::IndexString(), _cache(0x0), _cacheSize(0x0), 
  _fd(0x0), _indexFd(0x0), _filename(filename), _cnt(0)
{
  _fd = fopen(filename.c_str(), "w+b");
  if (!_fd)
    throw ToolBox::Exception("Could not open : " + filename, HERE);

  _indexFilename = filename + std::string(".off");
  _indexFd = fopen(_indexFilename.c_str(), "w+b");
  if (!_indexFd)
    throw ToolBox::Exception("Could not open : " + _indexFilename, HERE);
  
  // Warning, the cache size in parameter of constructor is for the
  // _memIndex vector and not for the result cache
  _cacheSize = 32768;
  _cache = new char[_cacheSize];
}

Index::DiskIndexString::~DiskIndexString()
{
  if (_cache)
    delete[] _cache;
  close();
}

void Index::DiskIndexString::close()
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

unsigned Index::DiskIndexString::addElement(const std::string &el)
{
  return addElement(el.c_str(), el.size());
}

unsigned Index::DiskIndexString::addElement(const char *str, unsigned strLen)
{
  assert(_indexFd != 0x0);
  assert(_fd != 0x0);

  if (fseeko(_fd, 0, SEEK_END) != 0 ||
      fseeko(_indexFd, 0, SEEK_END) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  diskEntry en(strLen, ftello(_fd));
  if (fwrite(&en, sizeof(diskEntry), 1, _indexFd) != 1)
    throw ToolBox::Exception("Invalid write to file", HERE);
  if (fwrite(str, strLen, 1, _fd) != 1)
    throw ToolBox::Exception("Invalid write to file", HERE);
  ++_cnt;
  return _cnt - 1;
}

unsigned Index::DiskIndexString::getNbElements() const
{
  return _cnt;
}

const char* Index::DiskIndexString::getElement(unsigned id) const
{
  if (id >= getNbElements())
    throw ToolBox::Exception("Invalid index", HERE);
  assert(_indexFd != 0x0);
  assert(_fd != 0x0);
  
  if (fseeko(_indexFd, (off_t)sizeof(diskEntry) * (off_t)id, SEEK_SET) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  diskEntry en(0, 0);
  if (fread(&en, sizeof(diskEntry), 1, _indexFd) != 1)
    throw ToolBox::Exception("file read error", HERE);

  if (en.nbChars > _cacheSize)
    { // realloc cache
      delete[] _cache;
      _cacheSize = en.nbChars + 1;
      _cache = new char[_cacheSize];
    }
  if (fseeko(_fd, en.position, SEEK_SET) != 0)
    throw ToolBox::Exception("file seek error", HERE);
  if (fread(_cache, en.nbChars, 1, _fd) != 1)
    throw ToolBox::Exception("file read error", HERE);
  _cache[en.nbChars] = 0;
  return _cache;
}
