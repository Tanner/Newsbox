/*
** Results.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep 25 22:05:33 2006 Julien Lemoine
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

#ifndef   	CLUSTERINGRESULTS_H_
# define   	CLUSTERINGRESULTS_H_

#include <vector>
#include <list>
#include "DocCluster.h"

namespace Algo { class Cluster; }

namespace Clustering
{
  /**
   * @brief simple wrapper to get results of clustering algorithm
   * (wrapper over class Algo::Cluster and Algo::Word)
   */
  class Results
    {
    public:
      Results(const std::list<const Algo::Cluster*> &clusters);
      ~Results();

    private:
      /// avoid default constructor
      Results();
      /// avoid copy constructor
      Results(const Results &e);
      /// avoid affectation operator
      Results& operator=(const Results &e);
	  
    public:
      DocClusterIterator begin() const;
      DocClusterIterator end() const;

    private:
      std::vector<DocCluster*>	_clusters;
    };
}

#endif 	    /* !CLUSTERINGRESULTS_H_ */
