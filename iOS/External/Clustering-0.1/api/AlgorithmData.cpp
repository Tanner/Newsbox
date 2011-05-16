/*
** AlgorithmData.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 20:42:08 2006 Julien Lemoine
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

#include "AlgorithmData.h"
#include "Exception.h"
#include "ports.h"
#include "DiskIndexUnsignedData.h"
#include "DiskIndexUnsignedInstance.h"
#include "IndexUnsignedIterator.h"
#include "DiskIndexString.h"
#include "MemoryIndexUnsignedData.h"
#include "MemoryIndexUnsignedInstance.h"
#include "FillRandomUnsignedIndex.h"
#include "InvertDiskUnsignedIndex.hxx"
#include "Trie.hxx"
#include "Hash.hxx"
#include "TrieNode.hxx"
#include "SimilarityMeasure.h"
#include "RusselAndRaoSimilarityMeasure.h"
#include "SimpleMatchingSimilarityMeasure.h"
#include "JaccardSimilarityMeasure.h"
#include "DiceSimilarityMeasure.h"
#include "SS1SimilarityMeasure.h"
#include "RTSimilarityMeasure.h"
#include "SS2SimilarityMeasure.h"
#include "K2SimilarityMeasure.h"

Clustering::AlgorithmData::AlgorithmData(const SimilarityKind similarity,
					 double threshold) :
  _affectAllDocuments(false), _useMemoryForPairsComputation(false),
  _docToElsDisk(0x0), _docToElsMem(0x0), _elToDocsDisk(0x0), _elToDocsMem(0x0),
  _docsName(0x0), _descriptors(0x0), _nbThread(1), _tmpPath("."), _threshold(threshold),
  _similarity(similarity), _nbMaxClusters(0), _docToId(0x0), _descriptorToId(0x0),
  _similarityMeasure(0x0)
{
  _docToId = new ToolBox::Trie<unsigned>(0);
  _descriptorToId = new ToolBox::Trie<unsigned>(0);
  _descriptorOfCurrentDocument = new ToolBox::Trie<bool>(false);
  //_descriptorToId = new ToolBox::Hash<unsigned>(0);
  //_descriptorOfCurrentDocument = new ToolBox::Hash<bool>(false);
}

Clustering::AlgorithmData::~AlgorithmData()
{
  _release();
  if (_descriptors)
    delete _descriptors;
  _descriptors = 0x0;
  if (_docsName)
    delete _docsName;
  _docsName = 0x0;
  if (_elToDocsDisk)
    delete _elToDocsDisk;
  _elToDocsDisk = 0x0;
  if (_elToDocsMem)
    delete _elToDocsMem;
  _elToDocsMem = 0x0;
}

void Clustering::AlgorithmData::_releaseTrie()
{
  if (_docToId)
    delete _docToId;
  _docToId = 0x0;
  if (_descriptorToId)
    delete _descriptorToId;
  _descriptorToId = 0x0;
}

void Clustering::AlgorithmData::_fillRevertIndex()
{
  if (_elToDocsDisk)
    {
      // We are using a sort-based algorithm to construct the revert
      // index.
      if (_docToElsDisk)
	{
	  Index::DiskIndexUnsignedInstance instance(*_docToElsDisk);
	  Index::InvertDiskUnsignedIndex<Index::DiskIndexUnsignedInstance> 
	    invert(instance, *_elToDocsDisk);
	  invert.start(_tmpPath, _nbThread, _cards);
	}
      else
	{
	  Index::MemoryIndexUnsignedInstance instance(*_docToElsMem);
	  Index::InvertDiskUnsignedIndex<Index::MemoryIndexUnsignedInstance>
	    invert(instance, *_elToDocsDisk);
	  invert.start(_tmpPath, _nbThread, _cards);
	}
    }
  else if (_elToDocsMem)
    {
      Index::FillRandomUnsignedIndex fill(*_elToDocsMem);
      _fillRevertIndexSub(fill);
    }
  else
    throw ToolBox::Exception("Revert index not found", HERE);

}

void Clustering::AlgorithmData::_fillRevertIndexSub(Index::FillRandomUnsignedIndex &fill)
{
  if (_docToElsDisk)
    {
      Index::DiskIndexUnsignedInstance instance(*_docToElsDisk);
      _cards.reserve(instance.getNbElements());
      for (unsigned int i = 0; i < instance.getNbElements(); ++i)
	{
	  Index::IndexUnsignedIterator iter = instance.getElement(i);
	  const unsigned *it = iter.begin();
	  const unsigned *ite = iter.end();
	  unsigned cnt = 0;
	  while (it != ite)
	    {
	      fill.setElement(*it, i);
	      ++it;
	      ++cnt;
	    }
	  _cards.push_back(cnt);
  	}
      fill.finalCheck();
    }
  else if (_docToElsMem)
    {
      Index::MemoryIndexUnsignedInstance instance(*_docToElsMem);
      _cards.reserve(instance.getNbElements());
      for (unsigned int i = 0; i < instance.getNbElements(); ++i)
	{
	  Index::IndexUnsignedIterator iter = instance.getElement(i);
	  const unsigned *it = iter.begin();
	  const unsigned *ite = iter.end();
	  unsigned cnt = 0;
	  while (it != ite)
	    {
	      fill.setElement(*it, i);
	      ++it;
	      ++cnt;
	    }
	  _cards.push_back(cnt);
  	}
      fill.finalCheck();
    }
  else
    throw ToolBox::Exception("Index not found", HERE);
}

Algo::SimilarityMeasure& Clustering::AlgorithmData::_getSimilarity()
{
  if (!_similarityMeasure)
    {
      unsigned nbDescs = 0;
      if (_elToDocsDisk)
	nbDescs = _elToDocsDisk->getNbElements();
      else if (_elToDocsMem)
	nbDescs = _elToDocsMem->getNbElements();
      else
	throw ToolBox::Exception("Revert index not found", HERE);

      switch (_similarity)
	{
	case RusselAndRao:
	  _similarityMeasure = new Algo::RusselAndRaoSimilarityMeasure(_cards, nbDescs);
	  break;
	case SimpleMatching:
	  _similarityMeasure = new Algo::SimpleMatchingSimilarityMeasure(_cards, nbDescs);
	  break;
	case Jaccard:
	  _similarityMeasure = new Algo::JaccardSimilarityMeasure(_cards, nbDescs);
	  break;
	case Dice:
	  _similarityMeasure = new Algo::DiceSimilarityMeasure(_cards, nbDescs);
	  break;
	case SokalAndSneath1:
	  _similarityMeasure = new Algo::SS1SimilarityMeasure(_cards, nbDescs);
	  break;
	case RogersAndTanimoto:
	  _similarityMeasure = new Algo::RTSimilarityMeasure(_cards, nbDescs);
	  break;
	case SokalAndSneath2:
	  _similarityMeasure = new Algo::SS2SimilarityMeasure(_cards, nbDescs);
	  break;
	case Kulczynski:
	  _similarityMeasure = new Algo::K2SimilarityMeasure(_cards, nbDescs);
	  break;
	}
    }
  if (!_similarityMeasure)
    throw ToolBox::Exception("Invalid Similarity kind", HERE);
  return *_similarityMeasure;
}

void Clustering::AlgorithmData::_release()
{
  if (_descriptorOfCurrentDocument)
    delete _descriptorOfCurrentDocument;
  _descriptorOfCurrentDocument = 0;
  _releaseTrie();
  if (_docToElsDisk)
    delete _docToElsDisk;
  _docToElsDisk = 0x0;
  if (_docToElsMem)
    delete _docToElsMem;
  _docToElsMem = 0x0;
  if (_similarityMeasure)
    delete _similarityMeasure;
  _similarityMeasure = 0x0;
  if (_elToDocsMem)
    _elToDocsMem->deleteContent();
}

void Clustering::AlgorithmData::_checkDocToEls()
{
  if (!_docToElsMem  && !_docToElsDisk)
    throw ToolBox::Exception("You need to call setRevertIndexInMemory or setRevertIndexOnDisk", HERE);
}

void Clustering::AlgorithmData::_checkElToDocs()
{
  if (!_elToDocsMem  && !_elToDocsDisk)
    throw ToolBox::Exception("You need to call setMainIndexInMemory or setMainIndexOnDisk", HERE);
}

unsigned Clustering::AlgorithmData::_getNbElement(unsigned descriptorId) const
{
  if (_elToDocsDisk)
    return _elToDocsDisk->getNbEntries(descriptorId);
  else if (_elToDocsMem)
    return _elToDocsMem->getNbEntries(descriptorId);
  throw ToolBox::Exception("No more available", HERE);
  return 0;
}

void Clustering::AlgorithmData::_addDescriptorId(unsigned descriptorId)
{
  // Note: if we are using a disk based reserved index, there is
  // nothing to add to this index. Reverted index will be constructed
  // with a sorted-based algorithm after main index construction.

  if (_elToDocsMem)
    _elToDocsMem->incFrequency(descriptorId - 1, 1);
  // add unique identifier
  if (_docToElsMem)
    _docToElsMem->addEntryCurrentElement(descriptorId - 1);
  else
    _docToElsDisk->addEntryCurrentElement(descriptorId - 1);
}

unsigned Clustering::AlgorithmData::_getDescriptorId(const char *str, unsigned strLen)
{
  if (!_descriptorToId)
    throw ToolBox::Exception("Method no more available", HERE);
  unsigned res = _descriptorToId->getEntry(str, strLen);

  // Note: if we are using a disk based reserved index, there is
  // nothing to add to this index. Reverted index will be constructed
  // with a sorted-based algorithm after main index construction.

  if (!res)
    {
      unsigned id = _descriptors->addElement(str, strLen);
      _descriptorToId->addEntry(str, strLen, id + 1);
      
      unsigned newId = 0;
      if (_elToDocsMem)
	{
	  newId = _elToDocsMem->addElement();
	  _elToDocsMem->incFrequency(newId, 1);
	  assert(newId == id);
	}
      res = id + 1;
    }
  else
    {
      if (_elToDocsMem)
	_elToDocsMem->incFrequency(res - 1, 1);
    }
  return res - 1;
}

void Clustering::AlgorithmData::_allocDocsName()
{
  if (!_docsName)
    {
      std::string indexFile = _tmpPath + ToolBox::DirectorySeparatorString + std::string("DocsName.idx");
      _docsName = new Index::DiskIndexString(indexFile);
    }
  if (!_descriptors)
    {
      std::string indexFile = _tmpPath + ToolBox::DirectorySeparatorString + std::string("Descriptors.idx");
      // we have a least 10 * nbDocs words in total...
      _descriptors = new Index::DiskIndexString(indexFile); 
    }
}

void Clustering::AlgorithmData::_allocDocToElsDisk(const std::string &filename)
{
  if (_docToElsDisk || _docToElsMem)
    throw ToolBox::Exception("Main index already set", HERE);
  _docToElsDisk = new Index::DiskIndexUnsignedData(filename);
  _allocDocsName();
}

void Clustering::AlgorithmData::_allocDocToElsMem(unsigned cacheSize)
{
  if (_docToElsDisk || _docToElsMem)
    throw ToolBox::Exception("Main index already set", HERE);
  _docToElsMem = new Index::MemoryIndexUnsignedData(cacheSize);
  _allocDocsName();
}

void Clustering::AlgorithmData::_allocElToDocsDisk(const std::string &filename)
{
  if (_elToDocsDisk || _elToDocsMem)
    throw ToolBox::Exception("Revert index already set", HERE);
  _elToDocsDisk = new Index::DiskIndexUnsignedData(filename);

}

void Clustering::AlgorithmData::_allocElToDocsMem(unsigned cacheSize)
{
  if (_elToDocsDisk || _elToDocsMem)
    throw ToolBox::Exception("Revert index already set", HERE);
  _elToDocsMem = new Index::MemoryIndexUnsignedData(cacheSize);
}
