/*
** SortDiskIndexCopy.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 21:25:09 2006 Julien Lemoine
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

#ifndef   	SORTDISKINDEXCOPY_H_
# define   	SORTDISKINDEXCOPY_H_

#include <utility>

namespace Index
{
  /**
   * class used to store an old pair <documentId, descriptorId> and
   * compare if a new one if equal or not to this one
   */
  class SortDiskIndexCopy
    {
    public:
      SortDiskIndexCopy();
      ~SortDiskIndexCopy();

    private:
      /// avoid copy constructor
      SortDiskIndexCopy(const SortDiskIndexCopy &e);
      /// avoid affectation operator
      SortDiskIndexCopy& operator=(const SortDiskIndexCopy &e);

    public:
      bool cmpEqual(const std::pair<unsigned, unsigned> &p1) const;
      void affect(const std::pair<unsigned, unsigned> &p1);
      std::pair<unsigned, unsigned> getObj() const;

    private:
      std::pair<unsigned, unsigned>	_element;
    };
}

#endif 	    /* !SORTDISKINDEXCOPY_H_ */
