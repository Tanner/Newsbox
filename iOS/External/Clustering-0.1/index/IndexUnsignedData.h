/*
** IndexUnsignedData.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Tue Sep 12 20:55:53 2006 Julien Lemoine
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

#ifndef   	INDEXUNSIGNEDDATA_H_
# define   	INDEXUNSIGNEDDATA_H_

namespace Index
{
  // forward declaration
  class FillRandomUnsignedIndex;

  /**
   * @brief Internal representation of index. You need to uses a class
   * IndexUnsignedInstance (on instance per thread to be able to use it)
   * Generic index that represents a list of integers for each
   * entry. For example : an index from word to the list of 
   * documents who have this word or from a document to the list of 
   * words in this document. All words and documents are refered
   * by id for performances purpose
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class IndexUnsignedData
    {
    protected:
      /// default constructor
      IndexUnsignedData();
      /// default destructor
      virtual ~IndexUnsignedData();

    private:
      /// avoid copy constructor
      IndexUnsignedData(const IndexUnsignedData &e);
      /// avoid affectation operator
      IndexUnsignedData& operator=(const IndexUnsignedData &e);

      /// virtual pure
    public:
      /// add a new element in index and return the id of this entry
      virtual unsigned addElement() = 0;
      /// add a set of elements in index
      virtual void addElements(unsigned nbElements) = 0;
      /// add an entry to current element
      virtual void addEntryCurrentElement(unsigned id) = 0;
      /// close file
      virtual void close() = 0;
      /// increass nb of elements for id of val
      virtual void incFrequency(unsigned id, unsigned val) = 0;
      /// return the number of elements
      virtual unsigned getNbElements() const = 0;
      /// return the number of entry for an element
      virtual unsigned getNbEntries(unsigned id) const = 0;

    protected:
      friend class FillRandomUnsignedIndex;
      /// initialize random fill mode
      virtual void _initRandomFill() = 0;
      /// fill an entry m[i][j] = val
      virtual void _setRandomVal(unsigned i, unsigned j, unsigned val) = 0;
    };
}

#endif 	    /* !INDEXUNSIGNEDDATA_H_ */
