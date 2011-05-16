/*
** K2SimilarityMeasure.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 17 20:37:12 2006 Julien Lemoine
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

#include "K2SimilarityMeasure.h"
#include "Cluster.h"

Algo::K2SimilarityMeasure::K2SimilarityMeasure(const std::vector<unsigned> &docCards,
						   unsigned nbDescriptors) :
  Algo::SimilarityMeasure(docCards, nbDescriptors)
{
}

Algo::K2SimilarityMeasure::~K2SimilarityMeasure()
{
}

double Algo::K2SimilarityMeasure::compute(const Cluster &c1, const Cluster &c2) const
{ 
  // Compute the first part : dot product between two clusters
  std::list<Word>::const_iterator wc1, wc1e = c1.getWords().end();
  std::list<Word>::const_iterator wc2, wc2e = c2.getWords().end();

  double a = 0, b = 0, c = 0, d = 0;
  for (wc1 = c1.getWords().begin(), wc2 = c2.getWords().begin(); wc1 != wc1e && wc2 != wc2e; )
    {
      if (wc1->wordId < wc2->wordId)
	++wc1;
      else if (wc2->wordId < wc1->wordId)
	++wc2;
      else // equal
	{
	  a += wc1->frequency * wc2->frequency;
	  ++wc1;
	  ++wc2;
	}
    }
  
  std::list<unsigned>::const_iterator dc1, dc1e = c1.getDocuments().end();
  std::list<unsigned>::const_iterator dc2, dc2e = c2.getDocuments().end();
  // Assume that two list of individuals are sorted
  double sizeC1 = c1.cardinal(), sizeC2 = c2.cardinal(), sumC1 = 0, sumC2 = 0;
  for (dc1 = c1.getDocuments().begin(); dc1 != dc1e; ++dc1)
    sumC1 += _getDocCard(*dc1);
  for (dc2 = c2.getDocuments().begin(); dc2 != dc2e; ++dc2)
    sumC2 += _getDocCard(*dc2);
  
  b = sizeC1 * sumC2 - a;
  c = sizeC2 * sumC1 - a;
  d = sizeC1 * sizeC2 * _getNbDescriptors() - a - b - c;

  double aplusc = a + c;
  double aplusb = a + b;
  double res = (a / aplusc + a / aplusb) / 2.0;

  return res;
}

double Algo::K2SimilarityMeasure::compute(unsigned docId1, unsigned docId2, unsigned inter) const
{
  double res = (double)inter / (double)_getDocCard(docId1) + (double)inter / (double)_getDocCard(docId2);
  res /= 2.0;
  return res;
}
