/*
** PairsIterator.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 19 22:20:15 2006 Julien Lemoine
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

#ifndef   	PAIRSITERATOR_H_
# define   	PAIRSITERATOR_H_

#include "PairArticles.h"

namespace Algo
{
  /**
   * @brief interface for pairs iterator
   * this interface describe the behavior of iterator
   */
  class PairsIterator
    {
    public:
      PairsIterator();
      virtual ~PairsIterator();

    public:
      virtual bool isEnd() const = 0;
      virtual PairsIterator& operator++() = 0;
      virtual const PairArticles& operator*() const = 0;
      virtual const PairArticles* operator->() const = 0;

    private:
      /// avoid postfix ++ operator
      PairsIterator& operator++(int);
    };
}

#endif 	    /* !PAIRSITERATOR_H_ */
