/*							-*- C++ -*-
** IndexUnsignedIterator.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 17:12:24 2006 Julien Lemoine
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

#ifndef   	DISKINDEXUNSIGNEDITERATOR_H_
# define   	DISKINDEXUNSIGNEDITERATOR_H_

namespace Index
{
  /**
   * @brief Class returned for reading of results, this is an easy way
   * of getting results for user of IndexUnsigned class
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class IndexUnsignedIterator
    {
    public:
      IndexUnsignedIterator(const unsigned *begin, const unsigned *end, 
				unsigned nb);
      ~IndexUnsignedIterator();

    private:
      /// avoid default constructor
      IndexUnsignedIterator();
  
    public:
      const unsigned* begin() const;
      const unsigned* end() const;
      unsigned nbElements() const;

    private:
      const unsigned	*_begin;
      const unsigned	*_end;
      unsigned		_nbEls;
    };
}

#endif 	    /* !DISKINDEXUNSIGNEDITERATOR_H_ */
