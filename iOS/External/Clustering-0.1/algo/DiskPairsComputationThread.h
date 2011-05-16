/*
** DiskPairsComputationThread.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 15:53:37 2006 Julien Lemoine
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

#ifndef   	DISKPAIRSCOMPUTATIONTHREAD_H_
# define   	DISKPAIRSCOMPUTATIONTHREAD_H_

#include <vector>
#include <list>
#include "PairArticles.h"
#include "PairsComputationThread.h"

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
  class DiskPairsComputationThread : public PairsComputationThread
    {
    public:
      DiskPairsComputationThread(const PairsComputationData &data, unsigned modulo,
				 Index::IndexUnsignedInstance &docToEls,
				 Index::IndexUnsignedInstance &elsToDocs,
				 const SortPairsArticles &sort);
      ~DiskPairsComputationThread();

    private:
      /// avoid default constructor
      DiskPairsComputationThread();
      /// avoid copy constructor
      DiskPairsComputationThread(const DiskPairsComputationThread &e);
      /// avoid affectation operator
      DiskPairsComputationThread& operator=(const DiskPairsComputationThread &e);

    public:
      const std::list<std::string>& getFiles() const;
      // thread initialization
      static void* init(void *param);
 
    private:
      void _start();
      void _addPairArticle(const unsigned first, const unsigned second,
			   const double similarity);
      void _endProcessing();
      void _dumpPairsToFile();

    private:
      unsigned				_nbFiles;
      std::list<std::string>		_files;
      std::vector<PairArticles>		_tmp;
    };
}

#endif 	    /* !DISKPAIRSCOMPUTATIONTHREAD_H_ */
