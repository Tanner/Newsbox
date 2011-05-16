/*
** API.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep 25 22:06:34 2006 Julien Lemoine
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

#include "API.h"
#include <assert.h>
#include <sstream>
#include <cmath>
#include "Exception.h"
#include "AlgorithmData.h"
#include "Trie.hxx"
#include "Hash.hxx"
#include "DiskIndexString.h"
#include "MemoryIndexUnsignedData.h"
#include "MemoryIndexUnsignedInstance.h"
#include "DiskIndexUnsignedInstance.h"
#include "DiskIndexUnsignedData.h"
#include "PairsComputation.h"
#include "ClusteringAlgorithm.h"

Clustering::API::API(Parameters &params) :
  _params(params), _results(0x0)
{
}

Clustering::API::~API()
{
  if (_results)
    delete _results;
}

Clustering::DocId Clustering::API::addDocument(const std::string &docName)
{
  if (!_params._getData()._docToId)
    throw ToolBox::Exception("Method no more available", HERE);
  if (!_params._getData()._descriptorOfCurrentDocument)
    throw ToolBox::Exception("Method no more available", HERE);
  // reinitalize the set of descriptor for this document
  _params._getData()._descriptorOfCurrentDocument->clear();

  if (!_params._getData()._docsName)
    throw ToolBox::Exception("You need to call setMainIndexInMemory or setMainIndexInDisk before", HERE);
  unsigned id = _params._getData()._docsName->addElement(docName), id2 = 0;
  _params._getData()._checkDocToEls();

  if (_params._getData()._docToElsMem)
    id2 = _params._getData()._docToElsMem->addElement();
  else
    id2 = _params._getData()._docToElsDisk->addElement();
  assert(id == id2);
  _params._getData()._docToId->addEntry(docName.c_str(), docName.size(), id + 1);
  return DocId(id);
}

const char* Clustering::API::getDocument(const DocId id)
{
  if (!_params._getData()._docsName)
    throw ToolBox::Exception("You need to call setMainIndexInMemory or setMainIndexInDisk before", HERE);
  return _params._getData()._docsName->getElement(id.getId());
}

Clustering::DocId Clustering::API::getDocument(const std::string &docName)
{
  if (!_params._getData()._docToId)
    throw ToolBox::Exception("Method no more available", HERE);
  unsigned id = _params._getData()._docToId->getEntry(docName.c_str(), docName.size());
  if (!id)
    throw ToolBox::Exception("Could not find document[" + docName + "]", HERE);
  return DocId(id - 1);
}

const char* Clustering::API::getDescriptor(const DescId id)
{
  if (!_params._getData()._descriptors)
    throw ToolBox::Exception("You have no string for descriptor", HERE);
  return _params._getData()._descriptors->getElement(id.getId());
}

void Clustering::API::addDescriptorInCurrentDocument(const std::string &descriptor)
{
  addDescriptorInCurrentDocument(descriptor.c_str(), descriptor.size());
}

void Clustering::API::addDescriptorInCurrentDocument(const char *str, unsigned strLen)
{
  if (!_params._getData()._descriptorOfCurrentDocument)
  _params._getData()._checkDocToEls();

  if (_params._getData()._descriptorOfCurrentDocument->getEntry(str, strLen))
    return; // descriptor already exist for this document

  // descriptor does not exist for this document, add it
  _params._getData()._descriptorOfCurrentDocument->addEntry(str, strLen, true);
  
  // get unique identifier for this descriptor
  unsigned id = _params._getData()._getDescriptorId(str, strLen);
  if (_params._getData()._docToElsMem)
    _params._getData()._docToElsMem->addEntryCurrentElement(id);
  else
    _params._getData()._docToElsDisk->addEntryCurrentElement(id);
}

void Clustering::API::addDescriptorInCurrentDocument(const std::string &descriptor, const unsigned descriptorId)
{
  addDescriptorInCurrentDocument(descriptor.c_str(), descriptor.size(), descriptorId);
}

void Clustering::API::addDescriptorInCurrentDocument(const char *str, unsigned strLen, const unsigned descriptorId)
{
  if (!_params._getData()._descriptorOfCurrentDocument)
    _params._getData()._checkDocToEls();

  if (_params._getData()._descriptorOfCurrentDocument->getEntry(str, strLen))
    return; // descriptor already exist for this document
  
  // descriptor does not exist for this document, add it
  _params._getData()._descriptorOfCurrentDocument->addEntry(str, strLen, true);

  // Add id to index
  _params._getData()._addDescriptorId(descriptorId);
}

unsigned Clustering::API::addDescriptor(const char *str, unsigned strLen)
{
  unsigned id = _params._getData()._descriptors->addElement(str, strLen);
  
  // Do not add element in _elToDocsDisk because convertion of main
  // index to revert index will do it
  if (_params._getData()._elToDocsMem)
    {
      unsigned newId = _params._getData()._elToDocsMem->addElement();
      assert(newId == id);
    }
  return id + 1;
}

class SortDescriptor
{
public:
  SortDescriptor(const Clustering::DescId &d, double q) : 
    descriptor(&d), quality(q)
  {}

public:
  const Clustering::DescId	*descriptor;
  double			quality;
};

bool inline sortDescriptor(const SortDescriptor &d1, 
			   const SortDescriptor &d2)
{
  return d1.quality > d2.quality;
}

std::vector<Clustering::DescId> Clustering::API::getBestDesc(const DocCluster &cluster, unsigned nbMaxDescs,
							     double minQuality)
{
  unsigned int i = 0;

  const std::vector<DescId> &descs = cluster.getDescs();
  std::vector<SortDescriptor>	d;
  d.reserve(descs.size());
  double clusterCardinal = cluster.getDocs().size();
  
  for (i = 0; i < descs.size(); ++i)
    {
      double descQuality = descs[i].getFrequency() / sqrt(clusterCardinal * 
							  _params._getData()._getNbElement(descs[i].getId()));
      d.push_back(SortDescriptor(descs[i], descQuality));
    }
  std::sort(d.begin(), d.end(), sortDescriptor);
  std::vector<Clustering::DescId> result;
  result.reserve(nbMaxDescs);
  for (i = 0; i < nbMaxDescs && i < descs.size(); ++i)
    result.push_back(*d[i].descriptor);
  return result;
}

const Clustering::Results& Clustering::API::startAlgorithm()
{
  AlgorithmData &data = _params._getData();

  // Relase Trie, they are no more usefull
  data._releaseTrie();

  // Check that everything is loaded
  data._checkDocToEls();
  data._checkElToDocs();

  // First of all fill the revert index with content of index
  data._fillRevertIndex();

  /// convert enum in similarity object
  Algo::SimilarityMeasure &similarity = data._getSimilarity();

  // Start pair computation
  Algo::PairsComputation compute(similarity, data._cards, data._threshold, 
				 data._useMemoryForPairsComputation);
  // Initialize Pair Computation
  if (data._docToElsDisk)
    compute.setDiskDocIndex(*data._docToElsDisk);
  else
    compute.setMemoryDocIndex(*data._docToElsMem);
  if (data._elToDocsDisk)
    compute.setDiskElIndex(*data._elToDocsDisk);
  else
    compute.setMemoryElIndex(*data._elToDocsMem);
  compute.setTemporaryFilePath(data._tmpPath);
    
  compute.setNbThread(data._nbThread);
  // Start Pairs Computation
  Algo::PairsIterator &pairsIt = *compute.start();

  // Handle pairs
  Index::IndexUnsignedInstance *instance = 0x0;
  if (data._docToElsDisk)
    instance = new Index::DiskIndexUnsignedInstance(*data._docToElsDisk);
  else
    instance = new Index::MemoryIndexUnsignedInstance(*data._docToElsMem);
  Algo::ClusteringAlgorithm algo(data._threshold, *instance, similarity);

  while (!pairsIt.isEnd())
    {
      algo.testMerge(pairsIt->first, pairsIt->second);
      ++pairsIt;
    }

  // release pairs.
  compute.releaseIterator(&pairsIt);

  std::list<const Algo::Cluster*> result = algo.finalize();

  // release algorithm and index
  delete instance;
  data._release();
 
  if (_results)
    delete _results;
  // convert clustering results in API::Results
  _results = new Results(result);
  return *_results;
}
