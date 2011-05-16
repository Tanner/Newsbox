/*
** SS1SimilarityMeasure.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 17 19:05:24 2006 Julien Lemoine
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

#ifndef   	SS1SIMILARITYMEASURE_H_
# define   	SS1SIMILARITYMEASURE_H_

#include "SimilarityMeasure.h"

namespace Algo
{
  /**
   * @brief implement the Sockal and Neath Similarity Measure 1 = 
   *  (2 * (a + d))/ (2 * (a + d) + c + d)
   *                          Doc 2 
   *                    Present | Absent
   * Doc 1  |Present       a        b
   *        |Absent        c        d
   */
  class SS1SimilarityMeasure : public SimilarityMeasure
    {
    public:
      SS1SimilarityMeasure(const std::vector<unsigned> &docCards,
			       unsigned nbDescriptors);
      ~SS1SimilarityMeasure();
      
    private:
      /// avoid copy constructor
      SS1SimilarityMeasure(const SS1SimilarityMeasure &e);
      /// avoid affectation operator
      SS1SimilarityMeasure& operator=(const SS1SimilarityMeasure &e);

    public:
      /// compute similarity between two clusters
      double compute(const Cluster &c1, const Cluster &c2) const;
      /// compute similarity between two documents
      double compute(unsigned docId1, unsigned docId2, unsigned inter) const;
   };
}

#endif 	    /* !SS1SIMILARITYMEASURE_H_ */
