/*
** MemoryPairsIterator.cc
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Thu Sep 21 23:04:09 2006 Julien Lemoine
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

#include "MemoryPairsIterator.h"

Algo::MemoryPairsIterator::MemoryPairsIterator(const std::vector<PairArticles> &res) :
  PairsIterator(), _endIt(res.end()), _it(res.begin())
{
}

Algo::MemoryPairsIterator::~MemoryPairsIterator()
{
}

Algo::MemoryPairsIterator&
Algo::MemoryPairsIterator::operator=(const MemoryPairsIterator &other)
{
  _endIt = other._endIt;
  _it = other._it;
  return *this;
}

bool Algo::MemoryPairsIterator::isEnd() const
{
  return _it == _endIt;
}

Algo::PairsIterator& Algo::MemoryPairsIterator::operator++()
{
  ++_it;
  return *this;
}

const Algo::PairArticles& Algo::MemoryPairsIterator::operator*() const
{
  return *_it;
}

const Algo::PairArticles* Algo::MemoryPairsIterator::operator->() const
{
  return &(*_it);
}
