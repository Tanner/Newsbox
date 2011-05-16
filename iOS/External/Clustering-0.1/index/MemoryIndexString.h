/*
** MemoryIndexString.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 18:16:34 2006 Julien Lemoine
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

#ifndef   	MEMORYINDEXSTRING_H_
# define   	MEMORYINDEXSTRING_H_

#include <vector>
#include <string>
#include "IndexString.h"

namespace ToolBox { class StringFactory; }

namespace Index
{
  /**
   * @brief Store an index containing a string for each
   * entry into memory. For example a lexicon
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class MemoryIndexString : public IndexString
    {
    public:
      /// default constructor
      MemoryIndexString(unsigned cacheSize);
      /// default destructor
      ~MemoryIndexString();

    private:
      /// avoid default constructor
      MemoryIndexString();
      /// avoid copy constructor
      MemoryIndexString(const MemoryIndexString &e);
      /// avoid affectation operator
      MemoryIndexString& operator=(const MemoryIndexString &e);

    public:
      /// add a new element in index and return the id of this entry
      unsigned addElement(const std::string &el);
      /// get string from an id
      const char* getElement(unsigned id) const;
      /// close file
      void close();
      /// get number of elements
      unsigned getNbElements() const;

    protected:
     /// represent a disk entry in memory
      class memEntry
      {
      public:
	memEntry(const char *ptr);

      public:
	/// string pointer
	const char	*str;
      };

     private:
      // store results in memory
      ToolBox::StringFactory	*_stringFactory;
      // store pointer to string
      std::vector<memEntry>	_memIndex;
    };
}

#endif 	    /* !MEMORYINDEXSTRING_H_ */
