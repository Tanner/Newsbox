/*
** PairsComputationThread.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 16:05:17 2006 Julien Lemoine
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

#ifndef   	PAIRSCOMPUTATIONTHREAD_H_
# define   	PAIRSCOMPUTATIONTHREAD_H_

#include <vector>
#include "PairArticles.h"

//fwd declaration
namespace Index { class IndexUnsignedInstance; }
namespace Algo { class SortPairsArticles; }
namespace Algo { class SimilarityMeasure; }
namespace Algo { class PairsComputationData; }

namespace Algo
{
  
  /**
   * @brief this class implement a processing thread 
   */
  class PairsComputationThread
    {
    public:
      PairsComputationThread(const PairsComputationData &data, unsigned modulo,
			     Index::IndexUnsignedInstance &docToEls,
			     Index::IndexUnsignedInstance &elsToDocs,
			     const SortPairsArticles &sort);
      virtual ~PairsComputationThread();

    private:
      /// avoid default constructor
      PairsComputationThread();
      /// avoid copy constructor
      PairsComputationThread(const PairsComputationThread &e);
      /// avoid affectation operator
      PairsComputationThread& operator=(const PairsComputationThread &e);

    protected:
      void _startMapAlgorithm();
      virtual void _addPairArticle(const unsigned first, const unsigned second, double similarity) = 0;
      virtual void _endProcessing() = 0;

    protected:
      const PairsComputationData	&_data;
      unsigned				_modulo;
      Index::IndexUnsignedInstance	&_docToEls;
      Index::IndexUnsignedInstance	&_elToDocs;
      const SortPairsArticles		&_sort;
    };
}


#endif 	    /* !PAIRSCOMPUTATIONTHREAD_H_ */
