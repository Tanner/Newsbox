/*
** Parameters.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep 25 22:19:29 2006 Julien Lemoine
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

#include <iostream>
#include "Parameters.h"
#include "AlgorithmData.h"
#include "Exception.h"
#include "ports.h"
#include "DiskIndexUnsignedData.h"
#include "MemoryIndexUnsignedData.h"

Clustering::Parameters::Parameters(const SimilarityKind similarity, const double similarityThreshold) :
  _datas(0x0)
{
  _datas = new AlgorithmData(similarity, similarityThreshold);
}

Clustering::Parameters::~Parameters()
{
  if (_datas)
    delete _datas;
}

void Clustering::Parameters::setThreshold(double threshold)
{
  _datas->_threshold = threshold;
}

void Clustering::Parameters::setMainIndexInMemory(unsigned cacheSize)
{
  _datas->_allocDocToElsMem(cacheSize);
}

void Clustering::Parameters::setMainIndexOnDisk()
{
  std::string indexFile = _datas->_tmpPath + ToolBox::DirectorySeparatorString + std::string("MainIndex.idx");
  _datas->_allocDocToElsDisk(indexFile);
}

void Clustering::Parameters::setRevertIndexInMemory(unsigned cacheSize)
{
  _datas->_allocElToDocsMem(cacheSize);
}

void Clustering::Parameters::setRevertIndexOnDisk()
{
  std::string indexFile = _datas->_tmpPath + ToolBox::DirectorySeparatorString + std::string("RevertIndex.idx");
  _datas->_allocElToDocsDisk(indexFile);
}

void Clustering::Parameters::setNumberOfThread(unsigned nbThreads)
{
  _datas->_nbThread = nbThreads;
}

void Clustering::Parameters::setTemporaryPath(const std::string &filename)
{
  _datas->_tmpPath = filename;
}

void Clustering::Parameters::useMemoryForPairsSort()
{
  _datas->_useMemoryForPairsComputation = true;
}

void Clustering::Parameters::setMaximumNumberOfClusters(unsigned maxNbClusters)
{
  _datas->_nbMaxClusters = maxNbClusters;
}

void Clustering::Parameters::affectAllDocumentsInACluster()
{
  _datas->_affectAllDocuments = true;
}

Clustering::AlgorithmData& Clustering::Parameters::_getData()
{
  return *_datas;
}
