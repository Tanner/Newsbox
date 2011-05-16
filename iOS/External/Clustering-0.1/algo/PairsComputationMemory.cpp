/*
** PairsComputationMemory.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 19 22:14:52 2006 Julien Lemoine
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

#include "PairsComputationMemory.h"
#include "MemoryPairsComputationThread.h"

Algo::MemoryPairsThreadIterator::MemoryPairsThreadIterator(const MemoryPairsComputationThread &t) :
  endIt(t.getRes().end()), it(t.getRes().begin())
{
}

Algo::MemoryPairsThreadIterator& 
Algo::MemoryPairsThreadIterator::operator=(const MemoryPairsThreadIterator &other)
{
  endIt = other.endIt;
  it = other.it;
  return *this;
}

Algo::MemoryPairsThreadIterator::~MemoryPairsThreadIterator()
{
}

Algo::PairsComputationMemory::PairsComputationMemory()
{
}

Algo::PairsComputationMemory::~PairsComputationMemory()
{
}
