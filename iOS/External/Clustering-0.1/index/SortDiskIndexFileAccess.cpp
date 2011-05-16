/*
** SortDiskIndexFileAccess.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 21:12:31 2006 Julien Lemoine
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

#include "SortDiskIndexFileAccess.h"
#include <assert.h>
#include "IndexIo.h"
#include "Exception.h"

Index::SortDiskIndexFileAccess::SortDiskIndexFileAccess(const char *filename, bool write) :
  _element(0, 0)
{
  if (write)
    _file = fopen(filename, "w+b");
  else
    _file = fopen(filename, "rb");
  if (!_file)
    throw ToolBox::Exception("Could not open : " + std::string(filename), HERE);
}

Index::SortDiskIndexFileAccess::~SortDiskIndexFileAccess()
{
  if (_file)
    fclose(_file);
}

bool Index::SortDiskIndexFileAccess::eof()
{
  if (_file)
    return feof(_file);
  return true;
}

void Index::SortDiskIndexFileAccess::readNextObject()
{
  assert(_file);
  indexRead(_file, _element.first, _element.second);
}

std::pair<unsigned, unsigned> Index::SortDiskIndexFileAccess::getObject() const
{
  return _element;
}

void Index::SortDiskIndexFileAccess::write(const std::pair<unsigned, unsigned> &pair)
{
  indexWrite(_file, pair.first, pair.second);
}

void Index::SortDiskIndexFileAccess::writeFreq(const std::pair<unsigned, unsigned> &pair, unsigned freq)
{
  fprintf(_file, "Freq[%d]\tDescriptor[%d]\n", freq, pair.second);
}

bool Index::SortDiskIndexFileAccess::_compareReadSortedFile(const SortDiskIndexFileAccess *file1, 
							    const SortDiskIndexFileAccess *file2)
{
  /// Should use greater than here (opposite of function used for bloc
  /// sort because we are in a heap)
  return file1->getObject().second > file2->getObject().second;
}
