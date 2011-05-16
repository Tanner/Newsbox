/*
** MemoryIndexUnsignedData.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 12 22:24:10 2006 Julien Lemoine
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

#ifndef   	MEMORYINDEXUNSIGNEDDATA_H_
# define   	MEMORYINDEXUNSIGNEDDATA_H_

#include <vector>
#include "IndexUnsignedData.h"

namespace Index
{
  // fwd declaration
  class MemoryIndexUnsignedInstance;
  class IndexUnsignedIterator;

  /**
   * @brief Store an index containing a list of integers for each
   * entry in memory. For example : an index from word to the list of 
   * documents who have this word or from a document to the list of 
   * words in this document. All words and documents are refered
   * by id for performances purpose
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class MemoryIndexUnsignedData : public IndexUnsignedData
    {
    public:
      /// default constructor
      MemoryIndexUnsignedData(unsigned cacheSize);
      /// default destructor
      ~MemoryIndexUnsignedData();

    private:
      /// avoid default constructor
      MemoryIndexUnsignedData();
      /// avoid copy constructor
      MemoryIndexUnsignedData(const MemoryIndexUnsignedData &e);
      /// avoid affectation operator
      MemoryIndexUnsignedData& operator=(const MemoryIndexUnsignedData &e);

    public:
      /// add a new element in index and return the id of this entry
      unsigned addElement();
      /// add a set of elements in index
      void addElements(unsigned nbElements);
      /// add an entry to current element
      void addEntryCurrentElement(unsigned id);
      /// close file
      void close();
      /// increass nb of elements for id of val
      void incFrequency(unsigned id, unsigned val);
      /// return the number of elements
      unsigned getNbElements() const;
      /// return the number of entry for an element
      unsigned getNbEntries(unsigned id) const;
      /// delete content (_content) but keep frequency information 
      void deleteContent();

    protected:
      friend class MemoryIndexUnsignedInstance;
      /// get an id
      IndexUnsignedIterator _getElement(unsigned id) const;
      /// initialize random fill mode
      void _initRandomFill();
      /// fill an entry m[i][j] = val
      void _setRandomVal(unsigned i, unsigned j, unsigned val);

    protected:
      /// represent a disk entry in memory
      class memEntry
      {
      public:
	memEntry(unsigned nbElements, unsigned pos);

      public:
	/// number of elements for this entry
	unsigned	nbElements;
	/// vector position
	unsigned	position;
      };

    private:
      /// file descriptor
      std::vector<unsigned>	*_content;
      /// memory index
      std::vector<memEntry>	_memIndex;
    };
}

#endif 	    /* !MEMORYINDEXUNSIGNEDDATA_H_ */
