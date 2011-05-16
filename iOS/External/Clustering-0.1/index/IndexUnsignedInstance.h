/*
** IndexUnsignedInstance.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep 13 21:42:02 2006 Julien Lemoine
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

#ifndef   	INDEXUNSIGNEDINSTANCE_H_
# define   	INDEXUNSIGNEDINSTANCE_H_

namespace Index
{
  // forward declaration
  class IndexUnsignedIterator;

  /**
   * @brief This class is just the interface of index unsigned
   * This index represents a list of integers for each
   * entry. For example : an index from word to the list of 
   * documents who have this word or from a document to the list of 
   * words in this document. All words and documents are refered
   * by id for performances purpose
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class IndexUnsignedInstance
    {
    public:
      /// default destructor
      virtual ~IndexUnsignedInstance();

    protected:
      /// default constructor
      IndexUnsignedInstance();

    public:
      /// get an entry
      virtual IndexUnsignedIterator getElement(unsigned id) const = 0;
      virtual unsigned getNbElements() const = 0;
    };
}

#endif 	    /* !INDEXUNSIGNEDINSTANCE_H_ */
