/*
** FillRandomUnsignedIndex.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 19:21:14 2006 Julien Lemoine
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

#ifndef   	FILLRANDOMUNSIGNEDINDEX_H_
# define   	FILLRANDOMUNSIGNEDINDEX_H_

#include <vector>

namespace Index
{
  // fwd declaration
  class IndexUnsignedData;

  /**
   * @brief Fill an index with random access, we know how many
   * elements will be append to each entry. This implementation will
   * do a lot of seek when using DiskIndexUnsigned and can be
   * slow. After fill, all access will need no/few seek
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class FillRandomUnsignedIndex
    {
    public:
      /// default constructor
      FillRandomUnsignedIndex(IndexUnsignedData &index);
      /// default destructor
      ~FillRandomUnsignedIndex();

    private:
      /// avoid default constructor
      FillRandomUnsignedIndex();
      /// avoid copy constructor
      FillRandomUnsignedIndex(const FillRandomUnsignedIndex &e);
      /// avoid affectation operator
      FillRandomUnsignedIndex& operator=(const FillRandomUnsignedIndex &e);

    public:
      /// append value val in entry id
      void setElement(unsigned id, unsigned val);
      /// final check
      void finalCheck();

    private:
      IndexUnsignedData		&_index;
      /// number of elements append for each entry
      std::vector<unsigned>	_nbAppends;
    };
}


#endif 	    /* !FILLRANDOMUNSIGNEDINDEX_H_ */
