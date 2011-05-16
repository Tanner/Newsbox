/*
** JaccardSimilarityMeasure.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 20:01:20 2006 Julien Lemoine
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

#ifndef   	JACCARDSIMILARITYMEASURE_H_
# define   	JACCARDSIMILARITYMEASURE_H_

#include "SimilarityMeasure.h"

namespace Algo
{
  /**
   * @brief implement the Jaccard Similarity Measure = a / (a + b + c)
   *                          Doc 2 
   *                    Present | Absent
   * Doc 1  |Present       a        b
   *        |Absent        c        d
   * Also known as (A inter B) / (A union B) when you consider the
   * document as a set of descriptor
   */
  class JaccardSimilarityMeasure : public SimilarityMeasure
    {
    public:
      JaccardSimilarityMeasure(const std::vector<unsigned> &docCards,
			       unsigned nbDescriptors);
      ~JaccardSimilarityMeasure();
      
    private:
      /// avoid copy constructor
      JaccardSimilarityMeasure(const JaccardSimilarityMeasure &e);
      /// avoid affectation operator
      JaccardSimilarityMeasure& operator=(const JaccardSimilarityMeasure &e);

    public:
      /// compute similarity between two clusters
      double compute(const Cluster &c1, const Cluster &c2) const;
      /// compute similarity between two documents
      double compute(unsigned docId1, unsigned docId2, unsigned inter) const;
   };
}

#endif 	    /* !JACCARDSIMILARITYMEASURE_H_ */
