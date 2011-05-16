/*
** MemoryPairsIterator.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Thu Sep 21 22:58:01 2006 Julien Lemoine
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

#ifndef   	MEMORYPAIRSITERATOR_H_
# define   	MEMORYPAIRSITERATOR_H_

#include <vector>
#include "PairsIterator.h"
#include "PairArticles.h"

namespace Algo
{
  /**
   * @brief interface for pairs iterator
   * this interface describe the behavior of iterator
   */
  class MemoryPairsIterator : public PairsIterator
    {
    public:
      MemoryPairsIterator(const std::vector<PairArticles> &res);
      ~MemoryPairsIterator();
      MemoryPairsIterator& operator=(const MemoryPairsIterator &other);

    public:
      bool isEnd() const;
      PairsIterator& operator++();
      const PairArticles& operator*() const;
      const PairArticles* operator->() const;

    private:
      ///avoid default constructor
      MemoryPairsIterator();
      /// avoid copy constructor
      MemoryPairsIterator(const MemoryPairsIterator &e);
      /// avoid postfix ++ operator
      MemoryPairsIterator& operator++(int);

    private:
	  std::vector<PairArticles>::const_iterator	_endIt;
      std::vector<PairArticles>::const_iterator	_it;
    };
}


#endif 	    /* !MEMORYPAIRSITERATOR_H_ */
