/*
** MemoryIndexUnsignedInstance.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep 13 21:46:08 2006 Julien Lemoine
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

#ifndef   	MEMORYINDEXUNSIGNEDINSTANCE_H_
# define   	MEMORYINDEXUNSIGNEDINSTANCE_H_

#include "IndexUnsignedInstance.h"
#include "MemoryIndexUnsignedData.h"

namespace Index
{
  /**
   * @brief Store an index containing a list of integers for each
   * entry in memory. For example : an index from word to the list of 
   * documents who have this word or from a document to the list of 
   * words in this document. All words and documents are refered
   * by id for performances purpose
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class MemoryIndexUnsignedInstance : public IndexUnsignedInstance
    {
    public:
      /// default constructor
      MemoryIndexUnsignedInstance(const MemoryIndexUnsignedData &data);
      /// default destructor
      ~MemoryIndexUnsignedInstance();

    private:
      /// avoid default constructor
      MemoryIndexUnsignedInstance();
      /// avoid copy constructor
      MemoryIndexUnsignedInstance(const MemoryIndexUnsignedInstance &e);
      /// avoid affectation operator
      MemoryIndexUnsignedInstance& operator=(const MemoryIndexUnsignedInstance &e);

    public:
      /// get elements
      IndexUnsignedIterator getElement(unsigned id) const;
      /// get number of elements in index
      unsigned getNbElements() const;

    private:
      const MemoryIndexUnsignedData &_data;
    };
}

#endif 	    /* !MEMORYINDEXUNSIGNEDINSTANCE_H_ */
