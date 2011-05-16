/*
** ClusteringParameters.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 20:01:36 2006 Julien Lemoine
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

#ifndef   	CLUSTERINGPARAMETERS_H_
# define   	CLUSTERINGPARAMETERS_H_

namespace Clustering
{
  // fwd declaration
  class AlgorithmData;
  class API;

  /**
   * @brief set of binary similarity measure implemented in the
   * software, you can choose one of them
   */
  typedef enum s_SimilarityKind
  {
    RusselAndRao,
    SimpleMatching,
    Jaccard,
    Dice,
    SokalAndSneath1,
    RogersAndTanimoto,
    SokalAndSneath2,
    Kulczynski
  } SimilarityKind;

  /**
   * @brief this class contains all the parameters that you can use to
   * customize the clustering algorithm
   */
  class Parameters
    {
    public:
      /**
       * @param similarityThreshold is the minimum similarity that two
       * documents must have to be selected as a candidate for
       * clustering. This threshold must be between 0 and 1.
       */
      Parameters(const SimilarityKind = Jaccard, const double similarityThreshold = 0.5);
      ~Parameters();

    public:
      /**
       * @brief change similarityThreshold. It is the minimum similarity that two
       * documents must have to be selected as a candidate for
       * clustering. This threshold must be between 0 and 1.
       */
      void setThreshold(double threshold);

      /**
       * @brief set that the main index will be stored in memory
       * (index document to descriptors). 
       * @parameters cacheSize is the number of documents allocated by
       * default (you can choose an approximation of the number of documents)
       */
      void setMainIndexInMemory(unsigned cacheSize = 1000000);
      /**
       * @brief set that the main index will be stored on disk 
       * (index document to descriptors). 
       */
      void setMainIndexOnDisk();

      /**
       * @brief set that the revert index will be stored in memory
       * (index descriptor to documents). If you want to put an index
       * in memory, choose this one, there is much access to the revert
       * index than to the main index.
       * @param cacheSize is the number of descriptors allocated by default
       */
      void setRevertIndexInMemory(unsigned cacheSize = 1000000);
      /**
       * @brief set that the revert index will be stored on disk
       * (index descriptor to documents).
       */
      void setRevertIndexOnDisk();

      /**
       * @brief set the number of threads that the clustering
       * algorithm can use. If you have a multi-processor computer choose
       * put the number of processor and if you have a multi-core
       * processor, choose the number of core.
       */
      void setNumberOfThread(unsigned nbThreads);
      
      /**
       * @brief set the path where temporary files will be stored. By
       * default the path is the current directory. Warning: this
       * option must be called first if you want to use a specific
       * directory for all temporary file because set*OnDisk method
       * create the file when you call the method.
       */
      void setTemporaryPath(const std::string &filename);

      /**
       * @brief if you set this option, the clustering algorithm will
       * use the memory instead of disk to store and store all the pairs
       * of documents. Choose this option only if you have few
       * documents and a lot of RAM.
       */
      void useMemoryForPairsSort();

      /**
       * @brief limit the number of cluster as output of clustering
       * algorithm. The number of cluster can be less than this number
       * but not greater
       */
      void setMaximumNumberOfClusters(unsigned maxNbClusters);

      /**
       * @brief if you set this option, every document will be set in
       * a cluster. By default you have a set of document that do not
       * have enough similarity with other document to be in a cluster,
       * these documents are not put in any cluster. With this option,
       * you can force these documents to be affected in a cluster.
       * Warning: This option will slow down a lot the algorithm
       * because there is a test for each document that are not
       * affected with any existing clusters. This option can be used
       * with the setMaximumNumberOfClusters option
       */
      void affectAllDocumentsInACluster();

    protected:
      friend class API;
      AlgorithmData& _getData();

    private:
      /// avoid copy constructor
      Parameters(const Parameters &e);
      /// avoid affectation operator
      Parameters& operator=(const Parameters &e);

    private:
      AlgorithmData	*_datas;
    };
}

#endif 	    /* !CLUSTERINGPARAMETERS_H_ */
