/*
** FillRandomUnsignedIndex.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep  2 19:29:24 2006 Julien Lemoine
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

#include <sstream>
#include "FillRandomUnsignedIndex.h"
#include "Exception.h"
#include "IndexUnsignedData.h"

Index::FillRandomUnsignedIndex::FillRandomUnsignedIndex(Index::IndexUnsignedData &index) :
  _index(index)
{
  // Fill vector with 0
  _nbAppends.resize(index.getNbElements(), 0);
  _index._initRandomFill();
}

Index::FillRandomUnsignedIndex::~FillRandomUnsignedIndex()
{
}

void Index::FillRandomUnsignedIndex::setElement(unsigned id, unsigned val)
{
  if (id >= _nbAppends.size())
    throw ToolBox::Exception("Invalid id", HERE);
  if (_nbAppends[id] == _index.getNbEntries(id))
    throw ToolBox::Exception("Could not append element for this entry", HERE);
  _index._setRandomVal(id, _nbAppends[id], val);
  ++_nbAppends[id];
}

void Index::FillRandomUnsignedIndex::finalCheck()
{
  for (unsigned int i = 0; i < _nbAppends.size(); ++i)
    if (_nbAppends[i] != _index.getNbEntries(i))
      {
	std::stringstream ss;
	ss << "Entry[" << i + 1 << "/" << _index.getNbElements() << "] not totaly filled : " 
	   << (_index.getNbEntries(i) - _nbAppends[i]) << " missing elements";
	throw ToolBox::Exception(ss.str(), HERE);
      }
}
