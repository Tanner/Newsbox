/*
** API.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 19:51:20 2006 Julien Lemoine
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

#ifndef   	CLUSTERINGAPI_H_
# define   	CLUSTERINGAPI_H_

#include "Results.h"
#include "DocId.h"
#include "DescId.h"

namespace Clustering
{
  // fwd declarations
  class Cluster;
  class Parameters;
  class Results;
  class DocCluster;

  /**
   * @brief this class is the user API of algorithm. You need to use
   * it to fill the data of algorithm and to launch algorithm
   */
  class API
    {
    public:
      API(Parameters &params);
      ~API();

    public:
      /**
       * @brief add a new document to the corpus
       * @param docName the name of document
       * @return the id of new document. The id is greater to 0
       */
      DocId addDocument(const std::string &docName);

      /**
       * @brief get the id of a document
       * @param docName the name of document
       * @return the id of new document, 0 if there is an error
       */
      DocId getDocument(const std::string &docName);

      /**
       * @brief get the name of a document from the id
       * @param id the id of document to search
       * @return the name of document
       */
      const char* getDocument(const DocId id);

      /**
       * @brief get the string of a descriptor from the id
       * @param id the id of descriptor to search
       * @return the descriptor
       */
      const char* getDescriptor(const DescId id);

      /**
       * @brief add a new descriptor for the current document (for
       * exemple a word, a set of words, a link, ...)
       */
      void addDescriptorInCurrentDocument(const std::string &descriptor);
      void addDescriptorInCurrentDocument(const char *str, unsigned strLen);

      /**
       * When you do not want to manage your descriptor id yourself,
       * you must register then with addDescriptor method, and then use
       * addDescriptorInCurrentDocument(string, unsigned) or
       * addDescriptorInCurrentDocument(const char *, unsigned, unsigned)
       */
      unsigned addDescriptor(const char *str, unsigned strLen);

      /**
       * @brief add a new descriptor for the current document (assume
       * that transformation of string to unsigned is done outside of
       * this class but with the same convention, first string = 1,
       * second = 2, ...)
       */
      void addDescriptorInCurrentDocument(const std::string &descriptor, const unsigned descriptorId);
      void addDescriptorInCurrentDocument(const char *str, unsigned strLen, const unsigned descriptorId);

      /**
       * @brief get the best descriptor of a cluster
       */
      std::vector<DescId> getBestDesc(const DocCluster &cluster, unsigned nbMaxDescs = 10,
				      double minQuality = 0.1);

      /**
       * @brief launch the algorithm and return the result
       */
      const Results& startAlgorithm();

    private:
      /// avoid default constructor
      API();
      /// avoid copy constructor
      API(const API &e);
      /// avoid affectation operator
      API& operator=(const API &e);

    private:
      Parameters	&_params;
      Results		*_results;
    };
}

#endif 	    /* !CLUSTERINGAPI_H_ */
