/*
** InvertDiskUnsignedIndex.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 22:01:19 2006 Julien Lemoine
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

#ifndef   	INVERTDISKUNSIGNEDINDEX_H_
# define   	INVERTDISKUNSIGNEDINDEX_H_

#include <string>
#include <vector>

namespace Index
{
  // fwd declaration
  class DiskIndexUnsignedData;
  class DiskIndexUnsignedInstance;

  /**
   * @brief at this step of processing we have the main index
   * documents -> descriptors and we want to create a reverted index 
   * descriptors -> documents.
   */
  template <class IndexInstance>
  class InvertDiskUnsignedIndex
    {
    public:
      InvertDiskUnsignedIndex(IndexInstance &mainIndex,
			      DiskIndexUnsignedData &revertIndex);
      ~InvertDiskUnsignedIndex();

    private:
      /// avoid default constructor
      InvertDiskUnsignedIndex();
      /// avoid copy constructor
      InvertDiskUnsignedIndex(const InvertDiskUnsignedIndex &e);
      /// avoid affectation operator
      InvertDiskUnsignedIndex& operator=(const InvertDiskUnsignedIndex &e);
      
    public:
      void start(const std::string &tmpPath, unsigned nbThreads,
		 std::vector<unsigned> &cards);

    private:
      IndexInstance		&_mainIndexInstance;
      DiskIndexUnsignedData	&_revertIndex;
    };
}

#endif 	    /* !INVERTDISKUNSIGNEDINDEX_H_ */
