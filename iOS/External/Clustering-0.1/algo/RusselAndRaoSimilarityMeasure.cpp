/*
** RusselAndRaoSimilarityMeasure.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 17 18:45:05 2006 Julien Lemoine
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

#include "RusselAndRaoSimilarityMeasure.h"
#include "Cluster.h"

Algo::RusselAndRaoSimilarityMeasure::RusselAndRaoSimilarityMeasure(const std::vector<unsigned> &docCards,
								   unsigned nbDescriptors) :
  Algo::SimilarityMeasure(docCards, nbDescriptors)
{
}

Algo::RusselAndRaoSimilarityMeasure::~RusselAndRaoSimilarityMeasure()
{
}

double Algo::RusselAndRaoSimilarityMeasure::compute(const Cluster &c1, const Cluster &c2) const
{ 
  // Compute the first part : dot product between two clusters
  std::list<Word>::const_iterator wc1, wc1e = c1.getWords().end();
  std::list<Word>::const_iterator wc2, wc2e = c2.getWords().end();

  double dotProduct = 0;
  for (wc1 = c1.getWords().begin(), wc2 = c2.getWords().begin(); wc1 != wc1e && wc2 != wc2e; )
    {
      if (wc1->wordId < wc2->wordId)
	++wc1;
      else if (wc2->wordId < wc1->wordId)
	++wc2;
      else // equal
	{
	  dotProduct += wc1->frequency * wc2->frequency;
	  ++wc1;
	  ++wc2;
	}
    }
  // in any case, a + b + c + d = nbwords
  double denum = c1.cardinal() * c2.cardinal() * _getNbDescriptors();
  return dotProduct / denum;
}

double Algo::RusselAndRaoSimilarityMeasure::compute(unsigned docId1, unsigned docId2, unsigned inter) const
{
  return (double)inter / (double) _getNbDescriptors();
}
