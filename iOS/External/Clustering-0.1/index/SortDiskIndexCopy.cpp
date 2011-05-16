/*
** SortDiskIndexCopy.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 21:59:28 2006 Julien Lemoine
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

#include "SortDiskIndexCopy.h"

Index::SortDiskIndexCopy::SortDiskIndexCopy() :
  _element(0, 0)
{
}
 
Index::SortDiskIndexCopy::~SortDiskIndexCopy()
{
}

bool Index::SortDiskIndexCopy::cmpEqual(const std::pair<unsigned, unsigned> &p1) const
{
  // we are comparing descriptors here...
  return p1.second == _element.second;
}

void Index::SortDiskIndexCopy::affect(const std::pair<unsigned, unsigned> &p1)
{
  _element = p1;
}

std::pair<unsigned, unsigned> Index::SortDiskIndexCopy::getObj() const
{
  return _element;
}
