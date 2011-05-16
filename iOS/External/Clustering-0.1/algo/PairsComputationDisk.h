/*
** PairsComputationDisk.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 19 22:33:59 2006 Julien Lemoine
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

#ifndef   	PAIRSCOMPUTATIONDISK_H_
# define   	PAIRSCOMPUTATIONDISK_H_

#include <list>
#include "PairArticles.h"
#include "DiskPairsIterator.h"

namespace Algo
{
  //fwd declarationm
  class DiskPairsComputationThread;

  /**
   * @brief class used during Merge of threads results. This class
   * represents a iterator to the files of PairArticle contained in
   * the Thread.
   */
  class DiskPairsThreadIterator
    {
    public:
      DiskPairsThreadIterator(const std::string &filename);
      ~DiskPairsThreadIterator();

    private:
      /// avoid default constructor
      DiskPairsThreadIterator();
      /// avoid copy constructor
      DiskPairsThreadIterator(const DiskPairsThreadIterator &e);
      /// avoid affectation operator
      DiskPairsThreadIterator& operator=(const DiskPairsThreadIterator &e);

    public:
      DiskPairsIterator	rit;

    private:
      std::string	_filename;
    };

  /**
   * @brief class containing all information needed for pairs
   * computation on disk
   */
  class PairsComputationDisk
    {
    public:
      PairsComputationDisk();
      ~PairsComputationDisk();

    private:
      /// avoid copy constructor
      PairsComputationDisk(const PairsComputationDisk &e);
      /// avoid affectation operator
      PairsComputationDisk& operator=(const PairsComputationDisk &e);

    public:
      /// threads
      std::list<DiskPairsComputationThread*>	processingThreads;
    };
}


#endif 	    /* !PAIRSCOMPUTATIONDISK_H_ */
