/*							-*- C++ -*-
** DocCluster.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Dec 17 11:59:29 2006 Julien Lemoine
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

#ifndef   	DOCCLUSTER_H_
# define   	DOCCLUSTER_H_

#include <vector>
#include "DocId.h"
#include "DescId.h"

namespace Algo		{ class Cluster;	}
namespace Clustering	{ class DocCluster;	}

namespace Clustering
{
  /**
   * @brief simple iterator over clusters
   */
  class DocClusterIterator
    {
    public:
      DocClusterIterator(unsigned el, const std::vector<DocCluster*> &v);
      ~DocClusterIterator();

    private:
      /// avoid default constructor
      DocClusterIterator();

    public:
      DocClusterIterator& operator++();
      const DocCluster& operator*() const;
      const DocCluster* operator->() const;
      bool operator==(const DocClusterIterator &other) const;
      bool operator!=(const DocClusterIterator &other) const;

    private:
      unsigned				_el;
      const std::vector<DocCluster*>	*_v;
    };

  /**
   * @brief cluster containing word and documents
   */
  class DocCluster
    {
    public:
      explicit DocCluster(const Algo::Cluster &origCluster);
      ~DocCluster();

    private:
      /// avoid default constructor
      DocCluster();
      /// avoid copy constructor
      DocCluster(const DocCluster &e);
      /// avoid affectation operator
      DocCluster& operator=(const DocCluster &e);

    public:
      /// get documents
      const std::vector<DocId>& getDocs() const;
      /// get descriptors
      const std::vector<DescId>& getDescs() const;

    private:
      /// vector of document for this class
      std::vector<DocId>	_docs;
      /// vector of words for this class
      std::vector<DescId>	_descs;
    };
}

#endif 	    /* !DOCCLUSTER_H_ */
