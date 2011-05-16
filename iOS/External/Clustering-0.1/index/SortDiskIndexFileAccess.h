/*
** SortDiskIndexFileAccess.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 21:12:01 2006 Julien Lemoine
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

#ifndef   	SORTDISKINDEXFILEACCESS_H_
# define   	SORTDISKINDEXFILEACCESS_H_

#include <stdio.h>
#include <utility>

namespace Index
{
  /**
   * @brief class that handle read/write of index pairs <documentId, descriptorId> in a file
   */
  class SortDiskIndexFileAccess
    {
    public:
      SortDiskIndexFileAccess(const char *filename, bool write);
      ~SortDiskIndexFileAccess();

    private:
      /// avoid default constructor
      SortDiskIndexFileAccess();
      /// avoid copy constructor
      SortDiskIndexFileAccess(const SortDiskIndexFileAccess &e);
      /// avoid affectation operator
      SortDiskIndexFileAccess& operator=(const SortDiskIndexFileAccess &e);

    public:
      bool eof();
      void readNextObject();
      std::pair<unsigned, unsigned> getObject() const;
      void write(const std::pair<unsigned, unsigned> &pair);
      void writeFreq(const std::pair<unsigned, unsigned> &pair, unsigned freq);
      static bool _compareReadSortedFile(const SortDiskIndexFileAccess *file1, const SortDiskIndexFileAccess *file2);

    public:
      FILE				*_file;
      // pair <documentId, descriptorId>
      std::pair<unsigned, unsigned>	_element;
    };
}

#endif 	    /* !SORTDISKINDEXFILEACCESS_H_ */
