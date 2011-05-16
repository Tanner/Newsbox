/*
** AlgorithmData.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 20:36:01 2006 Julien Lemoine
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

#ifndef   	ALGORITHMDATA_H_
# define   	ALGORITHMDATA_H_

#include <string>
#include <vector>
#include "Parameters.h"
#include "Trie.h"
#include "Hash.h"
#include "Results.h"

//Fwd declaration
namespace Index { class DiskIndexUnsignedData; }
namespace Index { class MemoryIndexUnsignedData; }
namespace Index { class DiskIndexString; }
namespace Index { class FillRandomUnsignedIndex; }
namespace Algo { class SimilarityMeasure; }

namespace Clustering
{
  class API;

  /**
   * @brief this class contains all the clustering data (index,
   * similarity, ...)
   */
  class AlgorithmData
    {
    public:
      AlgorithmData(const SimilarityKind similarity,
		    const double threshold);
      ~AlgorithmData();

    private:
      /// avoid default constructor
      AlgorithmData();
      /// avoid copy constructor
      AlgorithmData(const AlgorithmData &e);
      /// avoid affectation operator
      AlgorithmData& operator=(const AlgorithmData &e);

      //For simetrical alloc/desalloc
    protected:
      void _allocDocToElsDisk(const std::string &filename);
      void _allocDocToElsMem(unsigned cacheSize);
      void _allocElToDocsDisk(const std::string &filename);
      void _allocElToDocsMem(unsigned cacheSize);
      void _allocDocsName();

      // return the correct instance : disk or memory 
      void _checkDocToEls();
      // return the correct instance : disk or memory
      void _checkElToDocs();

      // add a descriptor occurance (descriptor must already exist)
      void _addDescriptorId(unsigned descriptorId);

      /// get descriptor id
      unsigned _getDescriptorId(const char *str, unsigned strLen);
      /// get number of document that contains this descriptor
      unsigned _getNbElement(unsigned descriptorId) const;

      /// release everything loaded in memory
      void _release();
      /// release string to id trie
      void _releaseTrie();

      /// fill revert and and fill _cards vector
      void _fillRevertIndex();

      /// convert SimilarityKind in SimilarityMeasure
      Algo::SimilarityMeasure& _getSimilarity();

      /// template method to fill revert index
      void _fillRevertIndexSub(Index::FillRandomUnsignedIndex &fill);

    protected:
      friend class Parameters;
      friend class API;
      bool				_affectAllDocuments;
      bool				_useMemoryForPairsComputation;

      Index::DiskIndexUnsignedData	*_docToElsDisk;
      Index::MemoryIndexUnsignedData	*_docToElsMem;

      Index::DiskIndexUnsignedData	*_elToDocsDisk;
      Index::MemoryIndexUnsignedData	*_elToDocsMem;
      
      Index::DiskIndexString		*_docsName;
      Index::DiskIndexString		*_descriptors;

      unsigned				_nbThread;
      std::string			_tmpPath;

      double				_threshold;
      SimilarityKind			_similarity;

      unsigned				_nbMaxClusters;

      ToolBox::Trie<unsigned>		*_docToId;
      ToolBox::Trie<unsigned>		*_descriptorToId;
      ToolBox::Trie<bool>		*_descriptorOfCurrentDocument;
      //ToolBox::Hash<unsigned>		*_descriptorToId;
      //ToolBox::Hash<bool>		*_descriptorOfCurrentDocument;

      std::vector<unsigned>		_cards;
      Algo::SimilarityMeasure		*_similarityMeasure;
    };
}

#endif 	    /* !ALGORITHMDATA_H_ */
