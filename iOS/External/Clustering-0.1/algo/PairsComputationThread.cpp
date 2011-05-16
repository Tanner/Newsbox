/*
** PairsComputationThread.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 16:08:09 2006 Julien Lemoine
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

#include "PairsComputationThread.h"
#include <iostream>
#include <map>
#include <algorithm>
#include "IndexUnsignedInstance.h"
#include "IndexUnsignedIterator.h"
#include "PairArticles.h"
#include "SimilarityMeasure.h"
#include "PairsComputationData.h"

Algo::PairsComputationThread::PairsComputationThread(const PairsComputationData &data, unsigned modulo,
						     Index::IndexUnsignedInstance &docToEls,
						     Index::IndexUnsignedInstance &elsToDocs,
						     const SortPairsArticles &sort) :
  _data(data), _modulo(modulo), _docToEls(docToEls), _elToDocs(elsToDocs), _sort(sort)
{
}

Algo::PairsComputationThread::~PairsComputationThread()
{
  
}

void  Algo::PairsComputationThread::_startMapAlgorithm()
{
  unsigned					nbDocuments = _docToEls.getNbElements();
  std::map<unsigned, unsigned>			scores;
  std::map<unsigned, unsigned>::iterator	mit, mite;

  for (unsigned i = 0; i < nbDocuments; ++i)
    if ((i % _data.nbThreads) == _modulo)
      {
	scores.clear();

	Index::IndexUnsignedIterator iter = _docToEls.getElement(i);
	const unsigned *wit, *wite = iter.end();
	// For each link, retrieve the list of article which have this link
	for (wit = iter.begin(); wit != wite; ++wit)
	  {
	    Index::IndexUnsignedIterator iter2 = _elToDocs.getElement(*wit);
	    const unsigned *dit, *dite = iter2.end();
	    for (dit = iter2.begin(); dit != dite; ++dit)
	      if (i < *dit)
		{
		  mit = scores.find(*dit);
		  if (mit == scores.end())
		    scores.insert(std::pair<unsigned, unsigned>(*dit, 1)); // inter = 1
		  else
		    ++mit->second;
		}
	  }
      double score;
      for (mit = scores.begin(), mite = scores.end(); mit != mite; ++mit)
	if (i < mit->first)
	  // First of all, avoid i == mit->first
	  // Then, score(i, j) = score(j, i). keep only one of the two
	  {
	    score = _data.similarity.compute(i, mit->first, mit->second);
	    if (score > _data.threshold)
	      _addPairArticle(i, mit->first, score);
	  }
    }
  _endProcessing();
}
