/*
** PairsComputation.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep 18 21:42:44 2006 Julien Lemoine
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

#include "PairsComputation.h"

#include <sstream>
#include <vector>
#include <algorithm>
#include <assert.h>
#include "Exception.h"
#include "ports.h"
#include "IndexUnsignedData.h"
#include "SimilarityMeasure.h"
#include "PairArticles.h"
#include "PairsComputationData.h"
#include "PairsComputationDisk.h"
#include "PairsComputationMemory.h"
#include "MemoryPairsComputationThread.h"
#include "DiskPairsComputationThread.h"
#include "MemoryPairsIterator.h"
#include "DiskPairsIterator.h"

Algo::PairsComputation::PairsComputation(SimilarityMeasure &similarity,
					 const std::vector<unsigned> &cards,
					 double threshold, bool useMemory) :
  _memoryData(0x0), _diskData(0x0), _commonData(0x0)
{
  _commonData = new PairsComputationData(similarity, cards, threshold, useMemory);
  _commonData->tmpPath = ".";
  if (useMemory)
    _memoryData = new PairsComputationMemory();
  else
    _diskData = new PairsComputationDisk();
}

Algo::PairsComputation::~PairsComputation()
{
  if (_commonData)
    delete _commonData;
  if (_diskData)
    delete _diskData;
  if (_memoryData)
    delete _memoryData;
}

void Algo::PairsComputation::setDiskDocIndex(const Index::DiskIndexUnsignedData &docToEls)
{
  if (!_commonData)
    throw ToolBox::Exception("No data object", HERE);
  if (_commonData->diskDocToEls || _commonData->memoryDocToEls)
    throw ToolBox::Exception("doc to elements index already set", HERE);
  _commonData->diskDocToEls = &docToEls;
}

void Algo::PairsComputation::setMemoryDocIndex(const Index::MemoryIndexUnsignedData &docToEls)
{
  if (!_commonData)
    throw ToolBox::Exception("No data object", HERE);
  if (_commonData->diskDocToEls || _commonData->memoryDocToEls)
    throw ToolBox::Exception("document to elements index already set", HERE);
  _commonData->memoryDocToEls = &docToEls;
}

void Algo::PairsComputation::setDiskElIndex(const Index::DiskIndexUnsignedData &elToDocs)
{
  if (!_commonData)
    throw ToolBox::Exception("No data object", HERE);
  if (_commonData->diskElToDocs || _commonData->memoryElToDocs)
    throw ToolBox::Exception("element to documents index already set", HERE);
  _commonData->diskElToDocs = &elToDocs;
}

void Algo::PairsComputation::setMemoryElIndex(const Index::MemoryIndexUnsignedData &elToDocs)
{
  if (!_commonData)
    throw ToolBox::Exception("No data object", HERE);
  if (_commonData->diskElToDocs || _commonData->memoryElToDocs)
    throw ToolBox::Exception("element to documents index already set", HERE);
  _commonData->memoryElToDocs = &elToDocs;
}


void Algo::PairsComputation::setTemporaryFilePath(const std::string &path)
{
  if (!_commonData)
    throw ToolBox::Exception("No data object", HERE);
  _commonData->tmpPath = path;
}

void Algo::PairsComputation::setNbThread(unsigned nbThreads)
{
  if (!_commonData)
    throw ToolBox::Exception("No data object", HERE);
  _commonData->nbThreads = nbThreads;
}

void Algo::PairsComputation::_startMultiThreadingDisk()
{
  DiskPairsComputationThread *type = 0x0;
  _startMultiThreading(_diskData, type);
}

inline bool Algo::PairsComputation::_cmpMemoryPairThreadIt(const MemoryPairsThreadIterator &firstIt,
							   const MemoryPairsThreadIterator &secondIt)
{
  assert(firstIt.it != firstIt.endIt);
  assert(secondIt.it != secondIt.endIt);

  return firstIt.it->similarity < secondIt.it->similarity;
}

inline bool Algo::PairsComputation::_cmpDiskPairThreadIt(const DiskPairsThreadIterator *firstIt,
							 const DiskPairsThreadIterator *secondIt)
{
  assert(firstIt->rit.isEnd() == false);
  assert(secondIt->rit.isEnd() == false);
  
  return firstIt->rit->similarity < secondIt->rit->similarity;
}

Algo::PairsIterator* Algo::PairsComputation::_mergeDisk()
{
  // Use a heap to merge results of N sorted files
  std::vector<DiskPairsThreadIterator*>			priorityQueue;
  std::list<DiskPairsThreadIterator*>::iterator			lit, tmp;
  std::list<DiskPairsComputationThread*>::const_iterator	it;
  std::list<std::string>::const_iterator			sit;
  SortPairsArticles						sort(_commonData->cards);

  unsigned pairsCnt = 0;
  priorityQueue.reserve(100);
  for (it = _diskData->processingThreads.begin(); it != _diskData->processingThreads.end(); ++it)
    {
      const std::list<std::string> &files = (*it)->getFiles();

        
      for (sit = files.begin(); sit != files.end(); ++sit)
	{
	  DiskPairsThreadIterator *dpit = new DiskPairsThreadIterator(*sit);
	  if (dpit->rit.isEnd() == false)
	    {
	      priorityQueue.push_back(dpit);
	      std::push_heap(priorityQueue.begin(), priorityQueue.end(), _cmpDiskPairThreadIt);
	    }
	  else
	    delete dpit;
	}
    }

  std::stringstream ss;
  ss << _commonData->tmpPath << ToolBox::DirectorySeparator << "MainPairsList.dat";
  FILE *pairs = fopen(ss.str().c_str(), "wb");
  if (!pairs)
    throw ToolBox::Exception("Could not open : " + ss.str(), HERE);

  DiskPairsThreadIterator *better = 0x0;
  unsigned queueSize = priorityQueue.size();
  while (queueSize > 0)
    {
      // get top of queue
      better = priorityQueue[0];
      std::pop_heap(priorityQueue.begin(), priorityQueue.begin() + queueSize, 
		    _cmpDiskPairThreadIt);

      if (better->rit.isEnd() == false)
	{
	  ++pairsCnt;
	  if (fwrite(&(*better->rit), sizeof(PairArticles), 1, pairs) != 1)
	    throw ToolBox::Exception("Write error", HERE);
	  ++better->rit;
	  if (better->rit.isEnd() == false)
	    {
	      priorityQueue[queueSize - 1] = better;
	      std::push_heap(priorityQueue.begin(), priorityQueue.begin() + queueSize, 
			     _cmpDiskPairThreadIt);
	    }
	}
		
      if (better->rit.isEnd() == true)
	{
	  delete better;
	  --queueSize;
	}
    }
	  
  for (it = _diskData->processingThreads.begin(); it != _diskData->processingThreads.end(); ++it)
    delete *it;
  fclose(pairs);
  std::cout << "Number of Pairs found (stored on disk) : " << pairsCnt << std::endl;
  return new DiskPairsIterator(ss.str(), true); // destroy the file after usage
}

void Algo::PairsComputation::_startMultiThreadingMemory()
{
  MemoryPairsComputationThread *type = 0x0;
  _startMultiThreading(_memoryData, type);
}

template <class dataType, class threadType>
void Algo::PairsComputation::_startMultiThreading(dataType *data, threadType *type)
{
  if (!data)
    throw ToolBox::Exception("No data loaded", HERE);

  std::list<pthread_t>			threads;
  std::list<pthread_t>::iterator	pit;
  pthread_attr_t			thread_attr;
  SortPairsArticles			sort(_commonData->cards);
  
  // for posix compatibility (not set by default on all architecture)
  pthread_attr_init(&thread_attr);
  pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_JOINABLE);
  pthread_attr_setscope(&thread_attr,  PTHREAD_SCOPE_SYSTEM);
  
  for (unsigned int i = 0; i < _commonData->nbThreads; ++i)
    {
      pthread_t thread;
      Index::IndexUnsignedInstance *docToElsInstance = _commonData->getNewDocToElsInstance();
      Index::IndexUnsignedInstance *elToDocsInstance = _commonData->getNewElToDocsInstance();
      threadType *processingThread = new threadType(*_commonData, i, *docToElsInstance, 
						    *elToDocsInstance,  sort);
      data->processingThreads.push_back(processingThread);
      int res = pthread_create(&thread, &thread_attr, threadType::init,
			       (void*)processingThread);
      if (res != 0)
	throw ToolBox::ThreadError("Could not create thread", HERE);
      threads.push_back(thread);
    }
  for (pit = threads.begin(); pit != threads.end(); ++pit)
    pthread_join(*pit, 0x0);
  _commonData->deleteInstances();
}

Algo::PairsIterator* Algo::PairsComputation::_mergeMemory()
{
  // Use a heap to merge N sorted results
  std::vector<MemoryPairsThreadIterator>					priorityQueue;
  std::list<MemoryPairsThreadIterator>::iterator			lit, tmp;
  std::list<MemoryPairsComputationThread*>::const_iterator	it;
  SortPairsArticles											sort(_commonData->cards);
  unsigned pairsCnt = 0;

  priorityQueue.reserve(100);
  unsigned size = 0;
  for (it = _memoryData->processingThreads.begin();
       it != _memoryData->processingThreads.end(); ++it)
    if ((*it)->getRes().size() > 0)
      {
	priorityQueue.push_back(MemoryPairsThreadIterator(**it));
	std::push_heap(priorityQueue.begin(), priorityQueue.end(), _cmpMemoryPairThreadIt);
	size += (*it)->getRes().size();
      }
  _memoryData->results.reserve(size);

  unsigned queueSize = priorityQueue.size();
  while (queueSize > 0)
    {
      // get top of queue
      MemoryPairsThreadIterator better = priorityQueue[0];
      std::pop_heap(priorityQueue.begin(), priorityQueue.begin() + queueSize, 
		    _cmpMemoryPairThreadIt);

      if (better.it != better.endIt)
	{
	  ++pairsCnt;
	  _memoryData->results.push_back(*better.it);
	  ++better.it;
	  if (better.it != better.endIt)
	    {
	      priorityQueue[queueSize - 1] = better;
	      std::push_heap(priorityQueue.begin(), priorityQueue.begin() + queueSize, 
			     _cmpMemoryPairThreadIt);
	    }
	}
      if (better.it == better.endIt)
	--queueSize;
    }
  for (it = _memoryData->processingThreads.begin(); 
       it != _memoryData->processingThreads.end(); ++it)
    delete *it;
  std::cout << "Number of Pairs found (stored in memory) : " << pairsCnt << std::endl;
  return new MemoryPairsIterator(_memoryData->results);
}

void Algo::PairsComputation::releaseIterator(const PairsIterator *it) const
{
  delete it;
}

Algo::PairsIterator* Algo::PairsComputation::start()
{
  if (!_commonData)
    throw ToolBox::Exception("No data object", HERE);

  if (_commonData->useMemory)
    {
      _startMultiThreadingMemory();
      return _mergeMemory();
    }
  else
    {
      _startMultiThreadingDisk();
      return _mergeDisk();
    }
}
