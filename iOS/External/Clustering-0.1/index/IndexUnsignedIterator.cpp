/*
** IndexUnsignedIterator.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 17:12:46 2006 Julien Lemoine
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

#include "IndexUnsignedIterator.h"


Index::IndexUnsignedIterator::
IndexUnsignedIterator(const unsigned *begin, const unsigned *end, unsigned nb) :
  _begin(begin), _end(end), _nbEls(nb)
{
}

Index::IndexUnsignedIterator::~IndexUnsignedIterator()
{
}

const unsigned* Index::IndexUnsignedIterator::begin() const
{
  return _begin;
}

const unsigned* Index::IndexUnsignedIterator::end() const
{
  return _end;
}

unsigned Index::IndexUnsignedIterator::nbElements() const
{
  return _nbEls;
}
