/*
** MemoryPairsComputationThread.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Thu Sep 21 23:15:40 2006 Julien Lemoine
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

#include "MemoryPairsComputationThread.h"
#include <iostream>
#include <map>
#include <algorithm>
#include "IndexUnsignedInstance.h"
#include "IndexUnsignedIterator.h"
#include "PairArticles.h"
#include "SimilarityMeasure.h"
#include "PairsComputationData.h"

Algo::MemoryPairsComputationThread::MemoryPairsComputationThread(const PairsComputationData &data, unsigned modulo,
								 Index::IndexUnsignedInstance &docToEls,
								 Index::IndexUnsignedInstance &elsToDocs,
								 const SortPairsArticles &sort) :
  PairsComputationThread(data, modulo, docToEls, elsToDocs, sort)
{
  _res.reserve(10000000);
}

Algo::MemoryPairsComputationThread::~MemoryPairsComputationThread()
{
  
}

const std::vector<Algo::PairArticles>& Algo::MemoryPairsComputationThread::getRes() const
{
  return _res;
}

void* Algo::MemoryPairsComputationThread::init(void *param)
{
  MemoryPairsComputationThread *thread = static_cast<MemoryPairsComputationThread*>(param);
  
  thread->_start();
  return 0x0;
}

void Algo::MemoryPairsComputationThread::_start()
{
  _startMapAlgorithm();
}

void Algo::MemoryPairsComputationThread::_addPairArticle(const unsigned first, const unsigned second,
							 const double similarity)
{
  _res.push_back(PairArticles(first, second, similarity));
}

void Algo::MemoryPairsComputationThread::_endProcessing()
{
  std::sort(_res.begin(), _res.end(), _sort);
}
