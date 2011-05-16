/*
** Cluster.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep  4 21:44:08 2006 Julien Lemoine
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

#ifndef   	CLUSTER_H_
# define   	CLUSTER_H_

#include <list>
#include <vector>
#include <iostream>
#include "Word.h"
#include "Exception.h"

namespace Algo
{
  // fwd declaration
  class ClusteringAlgorithm;

  /**
   * @brief Represent a cluster of documents storing a representative
   * (sum of document vector) and a list of documents
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class Cluster
    {
    public:
      Cluster();
      ~Cluster();

    private:
      /// avoid copy constructor
      Cluster(const Cluster &e);
      /// avoid affectation operator
      Cluster& operator=(const Cluster &e);
      
    public:
      /// check that content of cluster is ok (two list are well sorted)
      void check() const;
      /// add a word in cluster
      template <typename iterator>
      void addDocument(unsigned id, iterator beginWords, iterator endWords);
      template <typename iterator>
      void removeDocument(unsigned id, iterator beginWords, iterator endWords);
      /// add the content of other cluster in this one (union)
      void merge(const Cluster &other);
      /// get cardinal of cluster
      unsigned cardinal() const;
      ///get list of document
      const std::list<unsigned>& getDocuments() const;
      /// get list of words that this cluster contains
      const std::list<Word>& getWords() const;
      /// display content of cluster on ostream
      void display(std::ostream &os) const;

    protected:
      friend class ClusteringAlgorithm;
      std::list<unsigned>& _getDocuments();

    private:
      /// list of documents in this cluster
      std::list<unsigned> _documents;
      /// list of words in this cluster
      std::list<Word> _words;
      /// number of documents in this cluster
      unsigned	_cardinal;
    };
}

#endif 	    /* !CLUSTER_H_ */
