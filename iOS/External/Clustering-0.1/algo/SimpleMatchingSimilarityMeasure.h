/*
** SimpleMatchingSimilarityMeasure.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 17 18:48:22 2006 Julien Lemoine
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

#ifndef   	SIMPLEMATCHINGSIMILARITYMEASURE_H_
# define   	SIMPLEMATCHINGSIMILARITYMEASURE_H_

#include "SimilarityMeasure.h"

namespace Algo
{
  /**
   * @brief implement the Simple Matching Similarity Measure = 
   * (a + d) / (a + b + c + d)
   *                          Doc 2 
   *                    Present | Absent
   * Doc 1  |Present       a        b
   *        |Absent        c        d
   */
  class SimpleMatchingSimilarityMeasure : public SimilarityMeasure
    {
    public:
      SimpleMatchingSimilarityMeasure(const std::vector<unsigned> &docCards,
			       unsigned nbDescriptors);
      ~SimpleMatchingSimilarityMeasure();
      
    private:
      /// avoid copy constructor
      SimpleMatchingSimilarityMeasure(const SimpleMatchingSimilarityMeasure &e);
      /// avoid affectation operator
      SimpleMatchingSimilarityMeasure& operator=(const SimpleMatchingSimilarityMeasure &e);

    public:
      /// compute similarity between two clusters
      double compute(const Cluster &c1, const Cluster &c2) const;
      /// compute similarity between two documents
      double compute(unsigned docId1, unsigned docId2, unsigned inter) const;
   };
}

#endif 	    /* !SIMPLEMATCHINGSIMILARITYMEASURE_H_ */
