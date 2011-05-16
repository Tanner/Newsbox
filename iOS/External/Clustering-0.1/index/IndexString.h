/*
** IndexString.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 18:17:28 2006 Julien Lemoine
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

#ifndef   	INDEXSTRING_H_
# define   	INDEXSTRING_H_

#include <string>

namespace Index
{
  /**
   * @brief Internal representation of string index. You need to uses a class
   * DiskIndexString or MemoryIndexString and not this class
   * Generic index that represents a list of integers for each
   * entry. For example : an index from word to the list of 
   * documents who have this word or from a document to the list of 
   * words in this document. All words and documents are refered
   * by id for performances purpose
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class IndexString
    {
    protected:
      /// default constructor
      IndexString();
      /// default destructor
      virtual ~IndexString();

    private:
      /// avoid copy constructor
      IndexString(const IndexString &e);
      /// avoid affectation operator
      IndexString& operator=(const IndexString &e);

      /// virtual pure
    public:
      /// add a new element in index and return the id of this entry
      virtual unsigned addElement(const std::string &el) = 0;
      /// get string from an id
      virtual const char* getElement(unsigned id) const = 0;
      /// close file
      virtual void close() = 0;
      /// return the number of elements
      virtual unsigned getNbElements() const = 0;
    };
}

#endif 	    /* !INDEXSTRING_H_ */
