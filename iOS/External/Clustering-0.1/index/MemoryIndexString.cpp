/*
** MemoryIndexString.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 18:41:42 2006 Julien Lemoine
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

#include "MemoryIndexString.h"
#include "Exception.h"
#include "StringFactory.h"

Index::MemoryIndexString::memEntry::memEntry(const char *ptr) :
  str(ptr)
{
}

Index::MemoryIndexString::MemoryIndexString(unsigned cacheSize) :
  Index::IndexString(), _stringFactory(0x0)
{
  _memIndex.reserve(cacheSize);
  _stringFactory = new ToolBox::StringFactory(1000000);
}

Index::MemoryIndexString::~MemoryIndexString()
{
  delete _stringFactory;
}

unsigned Index::MemoryIndexString::addElement(const std::string &el)
{
  const char *str = _stringFactory->allocateString(el);
  _memIndex.push_back(memEntry(str));
  return _memIndex.size() - 1;
}

const char*  Index::MemoryIndexString::getElement(unsigned id) const
{
  if (id >= getNbElements())
    throw ToolBox::Exception("Invalid index", HERE);
  return _memIndex[id].str;
}

void Index::MemoryIndexString::close()
{
}

unsigned Index::MemoryIndexString::getNbElements() const
{
  return _memIndex.size();
}
