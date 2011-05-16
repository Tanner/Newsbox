/*
** DiskIndexUnsignedInstance.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep 13 21:58:22 2006 Julien Lemoine
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

#ifndef   	DISKINDEXUNSIGNEDINSTANCE_H_
# define   	DISKINDEXUNSIGNEDINSTANCE_H_

#include <stdio.h>
#include "IndexUnsignedInstance.h"
#include "DiskIndexUnsignedData.h"

namespace Index
{
  /**
   * @brief Store an index containing a list of integers for each
   * entry on disk. For example : an index from word to the list of 
   * documents who have this word or from a document to the list of 
   * words in this document. All words and documents are refered
   * by id for performances purpose
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class DiskIndexUnsignedInstance : public IndexUnsignedInstance
    {
    public:
      /// default constructor
      DiskIndexUnsignedInstance(const DiskIndexUnsignedData &data);
      /// default destructor
      ~DiskIndexUnsignedInstance();

    private:
      /// avoid default constructor
      DiskIndexUnsignedInstance();
      /// avoid copy constructor
      DiskIndexUnsignedInstance(const DiskIndexUnsignedInstance &e);
      /// avoid affectation operator
      DiskIndexUnsignedInstance& operator=(const DiskIndexUnsignedInstance &e);

    public:
      /// get an id
      IndexUnsignedIterator getElement(unsigned id) const;
      /// get number of elements in index
      unsigned getNbElements() const;

    private:
      const DiskIndexUnsignedData &_data;
      /// cache used for read
      mutable unsigned	*_cache;
      /// size of cache
      mutable unsigned	_cacheSize;
    };
}

#endif 	    /* !DISKINDEXUNSIGNEDINSTANCE_H_ */
