/*
** PairsComputationData.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 19 21:42:59 2006 Julien Lemoine
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

#include "PairsComputationData.h"
#include "DiskIndexUnsignedInstance.h"
#include "MemoryIndexUnsignedInstance.h"
#include "DiskIndexUnsignedData.h"
#include "MemoryIndexUnsignedData.h"
#include "Exception.h"

Algo::PairsComputationData::PairsComputationData(SimilarityMeasure &pSimilarity,
						 const std::vector<unsigned> &pCards,
						 double pThreshold, bool pUseMemory) :
  diskDocToEls(0x0), memoryDocToEls(0x0), diskElToDocs(0x0), memoryElToDocs(0x0),
  similarity(pSimilarity), nbThreads(1), cards(pCards), threshold(pThreshold), 
  useMemory(pUseMemory)
{
}

Algo::PairsComputationData::~PairsComputationData()
{
  deleteInstances();
}

Index::IndexUnsignedInstance* Algo::PairsComputationData::getNewDocToElsInstance()
{
  if (diskDocToEls && !memoryDocToEls)
    {
      Index::DiskIndexUnsignedInstance *instance = 
	new Index::DiskIndexUnsignedInstance(*diskDocToEls);
      _instances.push_back(instance);
      return instance;
    }
  else if (memoryDocToEls && !diskDocToEls)
    {
      Index::MemoryIndexUnsignedInstance *instance = 
	new Index::MemoryIndexUnsignedInstance(*memoryDocToEls);
      _instances.push_back(instance);
      return instance;
    }
  else
    throw ToolBox::Exception("Could not find documet to elements index", HERE);
}

Index::IndexUnsignedInstance* Algo::PairsComputationData::getNewElToDocsInstance()
{
  if (diskElToDocs && !memoryElToDocs)
    {
      Index::DiskIndexUnsignedInstance *instance = 
	new Index::DiskIndexUnsignedInstance(*diskElToDocs);
      _instances.push_back(instance);
      return instance;
    }
  else if (memoryElToDocs && !diskElToDocs)
    {
      Index::MemoryIndexUnsignedInstance *instance = 
	new Index::MemoryIndexUnsignedInstance(*memoryElToDocs);
      _instances.push_back(instance);
      return instance;
    }
  else
    throw ToolBox::Exception("Could not find element to documents index", HERE);  
}

void Algo::PairsComputationData::deleteInstances()
{
  std::list<Index::IndexUnsignedInstance*>::iterator it;

  for (it = _instances.begin(); it != _instances.end(); ++it)
    delete *it;
  _instances.clear();
}

