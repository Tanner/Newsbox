/*
** PairsComputationData.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 19 21:37:05 2006 Julien Lemoine
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

#ifndef   	PAIRSCOMPUTATIONDATA_H_
# define   	PAIRSCOMPUTATIONDATA_H_

#include <vector>
#include <string>
#include <list>

//fwd declaration
namespace Index { class DiskIndexUnsignedData; }
namespace Index { class MemoryIndexUnsignedData; }
namespace Index { class IndexUnsignedInstance; }
namespace Algo { class SimilarityMeasure; }

namespace Algo
{
  /**
   * @brief class used to hide the member of PairsComputation
   * class. This class contains the common parameters of
   * PairsComputation class.
   */
class PairsComputationData
  {
  public:
    PairsComputationData(SimilarityMeasure &similarity,
			 const std::vector<unsigned> &cards,
			 double threshold, bool useMemory);
    ~PairsComputationData();

  private:
    /// avoid default constructor
    PairsComputationData();
    /// avoid copy constructor
    PairsComputationData(const PairsComputationData &e);
    /// avoid affectation operator
    PairsComputationData& operator=(const PairsComputationData &e);

  public:
    Index::IndexUnsignedInstance* getNewDocToElsInstance();
    Index::IndexUnsignedInstance* getNewElToDocsInstance();
    void deleteInstances();

  public:
    /// index doc to words
    const Index::DiskIndexUnsignedData		*diskDocToEls;
    const Index::MemoryIndexUnsignedData	*memoryDocToEls;
    /// index word to docs
    const Index::DiskIndexUnsignedData		*diskElToDocs;
    const Index::MemoryIndexUnsignedData	*memoryElToDocs;
    /// similarity measure to use
    SimilarityMeasure				&similarity;
    /// number of threads
    unsigned					nbThreads;
    /// path where to store temporary file
    std::string					tmpPath;
    /// cardinals vector
    std::vector<unsigned>			cards;
    /// similarity threshold
    double					threshold;
    /// use memory for sort or disk
    bool					useMemory;

  private:
    /// instance to remove
    std::list<Index::IndexUnsignedInstance*>	_instances;
  };
}

#endif 	    /* !PAIRSCOMPUTATIONDATA_H_ */
