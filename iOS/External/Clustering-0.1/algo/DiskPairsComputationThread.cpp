/*
** DiskPairsComputationThread.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 15:57:38 2006 Julien Lemoine
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
#include "DiskPairsComputationThread.h"

#include <iostream>
#include <map>
#include <sstream>
#include <algorithm>
#include "IndexUnsignedInstance.h"
#include "IndexUnsignedIterator.h"
#include "PairArticles.h"
#include "SimilarityMeasure.h"
#include "ports.h"
#include "Exception.h"
#include "PairsComputationData.h"

Algo::DiskPairsComputationThread::DiskPairsComputationThread(const PairsComputationData &data, unsigned modulo,
							     Index::IndexUnsignedInstance &docToEls,
							     Index::IndexUnsignedInstance &elsToDocs,
							     const SortPairsArticles &sort) :
  PairsComputationThread(data, modulo, docToEls, elsToDocs, sort), _nbFiles(0)
{
  _tmp.reserve(1000000); //using 40 Mb maximum per thread seems reasonable
}

Algo::DiskPairsComputationThread::~DiskPairsComputationThread()
{
  
}

const std::list<std::string>& Algo::DiskPairsComputationThread::getFiles() const
{
  return _files;
}

void* Algo::DiskPairsComputationThread::init(void *param)
{
  DiskPairsComputationThread *thread = static_cast<DiskPairsComputationThread*>(param);
  
  thread->_start();
  return 0x0;
}
 
void  Algo::DiskPairsComputationThread::_start()
{
  _startMapAlgorithm();
}

void Algo::DiskPairsComputationThread::_dumpPairsToFile()
{
  std::stringstream ss;
  ss << _data.tmpPath << ToolBox::DirectorySeparator  << "sortThread" << _modulo << "."
     << _nbFiles;
  ++_nbFiles;
  std::sort(_tmp.begin(), _tmp.end(), _sort);
  FILE *file = fopen(ss.str().c_str(), "wb");
  if (!file)
    throw ToolBox::Exception("Could not open : " + ss.str(), HERE);
  _files.push_back(ss.str());
  unsigned nbWrite = 0;
  while (nbWrite < _tmp.size())
    nbWrite += fwrite(&_tmp[nbWrite], sizeof(PairArticles), _tmp.size() - nbWrite, file);
  fclose(file);
  _tmp.resize(0, PairArticles(0, 0, 0));
}

void Algo::DiskPairsComputationThread::_addPairArticle(const unsigned first, const unsigned second,
						       const double similarity)
{
  if (_tmp.size() == _tmp.capacity())
    _dumpPairsToFile();
  _tmp.push_back(PairArticles(first, second, similarity));
}

void Algo::DiskPairsComputationThread::_endProcessing()
{
  _dumpPairsToFile();
}
