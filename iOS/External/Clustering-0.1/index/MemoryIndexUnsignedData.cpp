/*
** MemoryIndexUnsignedData.cc
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 12 22:26:15 2006 Julien Lemoine
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

#include "MemoryIndexUnsignedData.h"
#include "Exception.h"
#include "MemoryIndexUnsignedData.h"
#include "IndexUnsignedIterator.h"

Index::MemoryIndexUnsignedData::memEntry::memEntry(unsigned nb, unsigned pos) :
  nbElements(nb), position(pos)
{
}

Index::MemoryIndexUnsignedData::MemoryIndexUnsignedData(unsigned cacheSize) :
  IndexUnsignedData(), _content(0x0)
{
  _memIndex.reserve(cacheSize);
  _content = new std::vector<unsigned>();
}

Index::MemoryIndexUnsignedData::~MemoryIndexUnsignedData()
{
  if (_content)
    delete _content;
}

unsigned Index::MemoryIndexUnsignedData::addElement()
{
  if (!_content)
    throw ToolBox::Exception("No more available", HERE);
  if (!_content->capacity())
    _content->reserve(_memIndex.capacity() * 10);

  _memIndex.push_back(memEntry(0, _content->size()));
  return _memIndex.size() - 1;
}

void Index::MemoryIndexUnsignedData::addElements(unsigned nbElements)
{
  if (!_content)
    throw ToolBox::Exception("No more available", HERE);
  _memIndex.resize(_memIndex.size() + nbElements, memEntry(0, 0));
}

void Index::MemoryIndexUnsignedData::addEntryCurrentElement(unsigned id)
{
  if (!_content)
    throw ToolBox::Exception("No more available", HERE);
  memEntry &entry = _memIndex.back();
  ++entry.nbElements;
  _content->push_back(id);
}

void Index::MemoryIndexUnsignedData::close()
{
  if (_content)
    _content->clear();
}

void Index::MemoryIndexUnsignedData::deleteContent()
{
  if (_content)
    delete _content;
  _content = 0x0;
}

void Index::MemoryIndexUnsignedData::incFrequency(unsigned id, unsigned val)
{
  if (id >= _memIndex.size())
    throw ToolBox::Exception("Invalid index", HERE);
  _memIndex[id].nbElements += val;
}

unsigned Index::MemoryIndexUnsignedData::getNbElements() const
{
  return _memIndex.size();
}

unsigned Index::MemoryIndexUnsignedData::getNbEntries(unsigned id) const
{
  if (id >= _memIndex.size())
    throw ToolBox::Exception("Invalid index", HERE);
  return _memIndex[id].nbElements;
}

Index::IndexUnsignedIterator Index::MemoryIndexUnsignedData::_getElement(unsigned id) const
{
  if (!_content)
    throw ToolBox::Exception("No more available", HERE);

  if (id >= _memIndex.size())
    throw ToolBox::Exception("Invalid index", HERE);
  const memEntry &entry = _memIndex[id];
  return IndexUnsignedIterator(&(*_content)[entry.position], 
			       &(*_content)[entry.position + entry.nbElements], 
			       entry.nbElements);
}

void Index::MemoryIndexUnsignedData::_initRandomFill()
{
  unsigned int i;

  if (!_content)
    throw ToolBox::Exception("No more available", HERE);

  // Fill position in _getMemIndex
  unsigned pos = 0;
  for (i = 0; i < _memIndex.size(); ++i)
    {
      _memIndex[i].position = pos;
      pos += _memIndex[i].nbElements;
    }
  _content->resize(pos, 0);
}

void Index::MemoryIndexUnsignedData::_setRandomVal(unsigned i, unsigned j, unsigned val)
{
  if (!_content)
    throw ToolBox::Exception("No more available", HERE);

  if (i >= _memIndex.size())
    throw ToolBox::Exception("Invalid id", HERE);
  const memEntry &en = _memIndex[i];
  (*_content)[en.position + j] = val;
}

