/*							-*- C++ -*-
** DescId.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Dec 17 11:58:11 2006 Julien Lemoine
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

#ifndef   	DESCID_H_
# define   	DESCID_H_

namespace Clustering
{
  /**
   * @brief class used to store descriptor id (and to do not mix
   * descriptor id with other unsigned id)
   */
  class DescId
    {
    public:
      DescId(unsigned descId, unsigned frequency);
      ~DescId();

    private:
      /// avoid default constructor
      DescId();

    public:
      const unsigned getId() const;
      const unsigned getFrequency() const;

    private:
      unsigned	_id;
      unsigned	_frequency;
    };
}

#endif 	    /* !DESCID_H_ */
