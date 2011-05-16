/*
** DiskIndexString.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 18:48:00 2006 Julien Lemoine
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

#ifndef   	DISKINDEXSTRING_H_
# define   	DISKINDEXSTRING_H_

#include <stdio.h>
#include <vector>
#include <string>

#include "IndexString.h"

namespace Index
{
  /**
   * @brief Store an index containing a string for each
   * entry on disk. For example a lexicon
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class DiskIndexString : public IndexString
    {
    public:
      /// default constructor
      DiskIndexString(const std::string &filename);
      /// default destructor
      ~DiskIndexString();

    private:
      /// avoid default constructor
      DiskIndexString();
      /// avoid copy constructor
      DiskIndexString(const DiskIndexString &e);
      /// avoid affectation operator
      DiskIndexString& operator=(const DiskIndexString &e);

    public:
      /// add a new element in index and return the id of this entry
      unsigned addElement(const std::string &el);
      unsigned addElement(const char *str, unsigned strLen);
      /// get string from an id
      const char* getElement(unsigned id) const;
      /// close file
      void close();
      /// get number of elements in index
      unsigned getNbElements() const;

    protected:
      /// represent a disk entry
      class diskEntry
      {
      public:
	diskEntry(unsigned nbChars, off_t position);

      public:
	/// number of characters for this entry
	unsigned	nbChars;
	/// position of entry in file
	off_t		position;
      };

    private:
      /// cache used for read
      mutable char	*_cache;
      /// size of cache
      mutable unsigned	_cacheSize;
      /// file descriptor (this file contains all strings)
      FILE		*_fd;
      /// index file descriptor (this file contains all position/length of strings)
      FILE		*_indexFd;
      /// file name
      std::string	_filename;
      /// file name of index
      std::string	_indexFilename;
      /// count number of string in index
      uint64_t		_cnt;
    };
}

#endif 	    /* !DISKINDEXSTRING_H_ */
