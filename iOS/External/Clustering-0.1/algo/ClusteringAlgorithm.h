/*
** ClusteringAlgorithm.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep  6 21:11:23 2006 Julien Lemoine
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

#ifndef   	CLUSTERINGQLGORITHM_H_
# define   	CLUSTERINGALGORITHM_H_

#include <list>
#include <vector>

namespace Index { class IndexUnsignedInstance; }
namespace Algo { class SimilarityMeasure; }

namespace Algo
{
  //Fwd declaration
  class Cluster;

  /**
   * @brief Contains the core of text clustering algorithm
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class ClusteringAlgorithm
    {
    public:
      ClusteringAlgorithm(double threshold,
			  Index::IndexUnsignedInstance &docIsndex,
			  SimilarityMeasure &similarity,
			  unsigned nbClustersMax = 0,
			  bool affectAllIndividuals = false);
      ~ClusteringAlgorithm();

    private:
      /// avoid default constructor
      ClusteringAlgorithm();
      /// avoid copy constructor
      ClusteringAlgorithm(const ClusteringAlgorithm &e);
      /// avoid affectation operator
      ClusteringAlgorithm& operator=(const ClusteringAlgorithm &e);
      
    public:
      /**
       * @brief try to merge two clusters. The first one is the cluster that
       * contains doc1 and the second is the cluster that contains
       * doc2
       */
      double testMerge(unsigned doc1, unsigned doc2);
      
      /**
       * finalize the clustering algorithm and return the clusters
       */
      std::list<const Cluster*> finalize();
      
    private:
      /// initialize menbers : create the new id
      void _init(const std::vector<unsigned> &cardinals);

    private:
      // similarity measure 
      SimilarityMeasure			&_similarity;
      /// clustering threshold
      double				_threshold;
      /// documents index : using old index
      Index::IndexUnsignedInstance	&_docsIndex;
      /// index document to cluster. Get the cluster associed to a document
      std::vector<Cluster*>		_indToCluster;
      /// maximum number of clusters (0 if there is no limit)
      unsigned				_nbClustersMax;
      /// number of clusters created
      unsigned				_nbClusters;
      /// when set to true, this force all individuals to be set in
      /// one cluster
      bool				_affectAllIndividuals;
    };
}

#endif 	    /* !CLUSTERINGALGORITHM_H_ */
