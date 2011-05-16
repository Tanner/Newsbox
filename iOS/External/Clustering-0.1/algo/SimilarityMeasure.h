/*
** SimilarityMeasure.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 19:50:17 2006 Julien Lemoine
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

#ifndef   	SIMILARITYMEASURE_H_
# define   	SIMILARITYMEASURE_H_

#include <vector>

namespace Algo
{
  // fwd declaration
  class Cluster;

  /**
   * @brief interface that represent a binary similarity measure used
   * for clustering algorithm (it can be Jaccard, Dice, Russel and Rao, ...)
   */
  class SimilarityMeasure
    {
    protected:
      SimilarityMeasure(const std::vector<unsigned> &docCards,
			unsigned nbDescriptors);
    public:
      virtual ~SimilarityMeasure();
      
    private:
      /// avoid copy constructor
      SimilarityMeasure(const SimilarityMeasure &e);
      /// avoid affectation operator
      SimilarityMeasure& operator=(const SimilarityMeasure &e);

    public:
      /// compute similarity between two clusters
      virtual double compute(const Cluster &c1, const Cluster &c2) const = 0;
      /// compute similarity between two documents
      virtual double compute(unsigned docId1, unsigned docId2, unsigned inter) const = 0;

    protected:
      unsigned _getDocCard(unsigned docId) const;
      unsigned _getNbDescriptors() const;

    private: 
      const std::vector<unsigned>	&_docCards;
      /// the total number of descriptors
      unsigned				_nbDescriptors;
   };
}

#endif 	    /* !SIMILARITYMEASURE_H_ */
