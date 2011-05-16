/*
** SortDiskIndexBloc.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 21:21:09 2006 Julien Lemoine
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

#include "SortDiskIndexBloc.h"
#include <algorithm>
#include <assert.h>

Index::SortDiskIndexBloc::SortDiskIndexBloc(unsigned blocSize)
{
  _index.reserve(blocSize);
}

Index::SortDiskIndexBloc::~SortDiskIndexBloc()
{
}

bool Index::SortDiskIndexBloc::isFull() const
{
  return _index.size() == _index.capacity();
}

void Index::SortDiskIndexBloc::clear()
{
  _index.reserve(0);
}

void Index::SortDiskIndexBloc::add(const std::pair<unsigned, unsigned> &el)
{
  //first = docId
  //second = descriptorId
  _index.push_back(el);
}

inline bool sortDiskIndexBlocCmp(const std::pair<unsigned, unsigned> &p1,
				 const std::pair<unsigned, unsigned> &p2)
{
  // we are sorting according to descriptorId in order to reverse the
  // index. We are using the opposite comparison function of
  // SortDiskIndexFileAccess::compareReadSortedFile
  return p1.second < p2.second;
}

void Index::SortDiskIndexBloc::sortLess()
{
  std::sort(_index.begin(), _index.end(), sortDiskIndexBlocCmp);
}

unsigned Index::SortDiskIndexBloc::getNbElements() const
{
  return _index.size();
}

const std::pair<unsigned, unsigned> Index::SortDiskIndexBloc::getElement(unsigned pos) const
{
  assert(pos < _index.size());
  return _index[pos];
}
