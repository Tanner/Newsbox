/*							-*- C++ -*-
** DiskIndexUnsignedData.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 16:42:21 2006 Julien Lemoine
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

#ifndef   	DISKINDEXUNSIGNEDDATA_H_
# define   	DISKINDEXUNSIGNEDDATA_H_

#include <pthread.h>
#include <stdio.h>
#include <string>
#include "IndexUnsignedData.h"

namespace Index
{
  // fwd declaration
  class DiskIndexUnsignedInstance;
  class IndexUnsignedIterator;

  /**
   * @brief Store an index containing a list of integers for each
   * entry on disk. For example : an index from word to the list of 
   * documents who have this word or from a document to the list of 
   * words in this document. All words and documents are refered
   * by id for performances purpose
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class DiskIndexUnsignedData : public IndexUnsignedData
    {
    public:
      /// default constructor
      DiskIndexUnsignedData(const std::string &filename);
      /// default destructor
      ~DiskIndexUnsignedData();

    private:
      /// avoid default constructor
      DiskIndexUnsignedData();
      /// avoid copy constructor
      DiskIndexUnsignedData(const DiskIndexUnsignedData &e);
      /// avoid affectation operator
      DiskIndexUnsignedData& operator=(const DiskIndexUnsignedData &e);

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
 
    protected:
      friend class DiskIndexUnsignedInstance;
      /// get an id
      IndexUnsignedIterator _getElement(unsigned id, unsigned* &cache, unsigned &cacheSize) const;
      /// initialize random fill mode
      void _initRandomFill();
      /// fill an entry m[i][j] = val
      void _setRandomVal(unsigned i, unsigned j, unsigned val);

    protected:
      /// represent a disk entry in memory
      class diskEntry
      {
      public:
	diskEntry(unsigned nbElements, off_t position);

      public:
	/// number of elements for this entry
	unsigned	nbElements;
	/// vector position
	off_t		filePosition;
      };
      diskEntry _getEntry(unsigned id) const;
      void _setEntry(unsigned id, const diskEntry &entry);

    private:
      /// mutex on file to avoid multiple instance reading in the file
      /// at the same time
      mutable pthread_mutex_t	_fileMutex;
      /// file descriptor
      FILE			*_fd;
      /// file name
      std::string		_filename;
      /// index file descriptor
      mutable FILE		*_indexFd;
      /// index file name
      std::string		_indexFilename;
      /// number of entries
      uint64_t			_cnt;
    };
}

#endif 	    /* !DISKINDEXUNSIGNEDDATA_H_ */
