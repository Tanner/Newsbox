/*							-*- C++ -*-
** DocId.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Dec 17 11:52:11 2006 Julien Lemoine
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

#ifndef   	DOCID_H_
# define   	DOCID_H_

namespace Clustering
{
  /**
   * @brief class used to store document id (and to do not mix
   * document id with other unsigned id)
   */
  class DocId
    {
    public:
      DocId(unsigned id);
      ~DocId();

    private:
      /// avoid default constructor
      DocId();

    public:
      /// get document id
      const unsigned getId() const;

    private:
      unsigned	_id;
    };
}

#endif 	    /* !DOCID_H_ */
