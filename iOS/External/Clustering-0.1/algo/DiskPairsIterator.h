/*
** DiskPairsIterator.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 17:08:50 2006 Julien Lemoine
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

#ifndef   	DISKPAIRSITERATOR_H_
# define   	DISKPAIRSITERATOR_H_

#include <string>
#include <stdio.h>
#include "PairsIterator.h"
#include "PairArticles.h"

namespace Algo
{
  /**
   * @brief interface for pairs iterator
   * this interface describe the behavior of iterator
   */
  class DiskPairsIterator : public PairsIterator
    {
    public:
      DiskPairsIterator(const std::string &file, bool deleteFile = false);
      ~DiskPairsIterator();

    public:
      bool isEnd() const;
      PairsIterator& operator++();
      const PairArticles& operator*() const;
      const PairArticles* operator->() const;

    private:
      ///avoid default constructor
      DiskPairsIterator();
      /// avoid copy constructor
      DiskPairsIterator(const DiskPairsIterator &e);
      /// avoid affectation operator
      DiskPairsIterator& operator=(const DiskPairsIterator &e);
      /// avoid postfix ++ operator
      DiskPairsIterator& operator++(int);

    private:
      bool		_delete;
      const std::string	_filename;
      FILE		*_fd;
      PairArticles	_current;
    };
}

#endif 	    /* !DISKPAIRSITERATOR_H_ */
