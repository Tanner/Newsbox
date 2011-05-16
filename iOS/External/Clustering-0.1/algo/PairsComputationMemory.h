/*
** PairsComputationMemory.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 19 21:47:53 2006 Julien Lemoine
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

#ifndef   	PAIRSCOMPUTATIONMEMORY_H_
# define   	PAIRSCOMPUTATIONMEMORY_H_

#include <list>
#include <vector>
#include "PairArticles.h"

namespace Algo
{
  //fwd declarationm
  class MemoryPairsComputationThread;

  /**
   * @brief class used during Merge of threads results. This class
   * represents a iterator to the vector of PairArticle contained in
   * the Thread.
   */
  class MemoryPairsThreadIterator
    {
    public:
      MemoryPairsThreadIterator(const MemoryPairsComputationThread &t);
      ~MemoryPairsThreadIterator();
	  MemoryPairsThreadIterator& operator=(const MemoryPairsThreadIterator &t);

    private:
      /// avoid default constructor
      MemoryPairsThreadIterator();

    public:
      /// reference to the thread
      std::vector<PairArticles>::const_iterator endIt;
      /// iterator to current element in the thread
      std::vector<PairArticles>::const_iterator	it;
    };

  /**
   * @brief class containing all information needed for pairs
   * computation in memory
   */
  class PairsComputationMemory
    {
    public:
      PairsComputationMemory();
      ~PairsComputationMemory();

    private:
      /// avoid copy constructor
      PairsComputationMemory(const PairsComputationMemory &e);
      /// avoid affectation operator
      PairsComputationMemory& operator=(const PairsComputationMemory &e);

    public:
      /// threads
      std::list<MemoryPairsComputationThread*>	processingThreads;
      /// result
      std::vector<PairArticles>			results;
    };
}

#endif 	    /* !PAIRSCOMPUTATIONMEMORY_H_ */
