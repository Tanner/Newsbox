/*
** PairsComputation.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 19:32:22 2006 Julien Lemoine
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

#ifndef   	PAIRSCOMPUTATION_H_
# define   	PAIRSCOMPUTATION_H_

#include <vector>
#include <string>
#include "PairsIterator.h"

//fwd declaration
namespace Index { class DiskIndexUnsignedData; }
namespace Index { class MemoryIndexUnsignedData; }
namespace Algo { class SimilarityMeasure; }
namespace Algo { class ClusteringAlgorithm; }
namespace Algo { class PairsComputationMemory; }
namespace Algo { class PairsComputationDisk; }
namespace Algo { class PairsComputationData; }
namespace Algo { class DiskPairsThreadIterator; }
namespace Algo { class MemoryPairsThreadIterator; }
namespace UnitTest { class TestComputePairsMemory; }
namespace UnitTest { class TestComputePairsMemoryThread; }
namespace UnitTest { class TestComputePairsDisk; }
namespace UnitTest { class TestComputePairsDiskThread; }

class TestPairsComputation;

namespace Algo
{
  /**
   * @brief this class implement the computation of all pairs from
   * index and the sort them. This class also allow to choose between
   * memory or disk storage and number of threads (really usefull if
   * you have a multi core processor)
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class PairsComputation
    {
    public:
      PairsComputation(SimilarityMeasure &similarity,
		       const std::vector<unsigned> &cards,
		       double threshold, bool useMemory);
      ~PairsComputation();

    private:
      /// avoid default constructor
      PairsComputation();
      /// avoid copy constructor
      PairsComputation(const PairsComputation &e);
      /// avoid affectation operator
      PairsComputation& operator=(const PairsComputation &e);

    public:
      void setDiskDocIndex(const Index::DiskIndexUnsignedData &docToEls);
      void setMemoryDocIndex(const Index::MemoryIndexUnsignedData &docToEls);
      void setDiskElIndex(const Index::DiskIndexUnsignedData &elToDocs);
      void setMemoryElIndex(const Index::MemoryIndexUnsignedData &elToDocs);
      /// set path where temporary file will be stored
      void setTemporaryFilePath(const std::string &path);
      /// set the number of thread to use (default = 1)
      void setNbThread(unsigned nbThreads);
      /// start pairs computation and return an iterator on the result
      PairsIterator* start();
      void releaseIterator(const PairsIterator *it) const;

    protected:
      /// friend for unit test purpose
      friend class UnitTest::TestComputePairsMemory;
      friend class UnitTest::TestComputePairsMemoryThread;
      friend class UnitTest::TestComputePairsDisk;
      friend class UnitTest::TestComputePairsDiskThread;

      void _startMultiThreadingDisk();
      PairsIterator* _mergeDisk();
      void _startMultiThreadingMemory();
      PairsIterator* _mergeMemory();
      template <class dataType, class threadType>
      void _startMultiThreading(dataType *data, threadType *type);

      /// compare two disk pairs thread iterator
      static bool _cmpDiskPairThreadIt(const DiskPairsThreadIterator *firstIt,
				       const DiskPairsThreadIterator *secondIt);
      
      /// compare two memory pairs thread iterator
      static bool _cmpMemoryPairThreadIt(const MemoryPairsThreadIterator &firstIt,
					 const MemoryPairsThreadIterator &secondIt);


    protected:
      /// Data class when doing processing in memory
      PairsComputationMemory	*_memoryData;
      /// Data class when doing processing on disk
      PairsComputationDisk	*_diskData;
      /// common data (hidden)
      PairsComputationData	*_commonData;
    };
}

#endif 	    /* !PAIRSCOMPUTATION_H_ */
