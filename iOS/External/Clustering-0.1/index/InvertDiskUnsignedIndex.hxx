/*
** InvertDiskUnsignedIndex.hxx
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 22:02:59 2006 Julien Lemoine
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

#ifndef   	INVERTDISKUNSIGNEDINDEX_HXX_
# define   	INVERTDISKUNSIGNEDINDEX_HXX_

#include "InvertDiskUnsignedIndex.h"
#include <assert.h>
#include "ports.h"
#include "Exception.h"
#include "DiskIndexUnsignedData.h"
#include "DiskIndexUnsignedInstance.h"
#include "IndexIo.h"
#include "SortDiskIndex.h"
#include "IndexUnsignedIterator.h"

template <class IndexInstance>
Index::InvertDiskUnsignedIndex<IndexInstance>::
InvertDiskUnsignedIndex(IndexInstance &mainIndex,
			DiskIndexUnsignedData &revertIndex) :
  _mainIndexInstance(mainIndex), _revertIndex(revertIndex)
{
}

template <class IndexInstance>
Index::InvertDiskUnsignedIndex<IndexInstance>::~InvertDiskUnsignedIndex()
{
}

template <class IndexInstance>
void Index::InvertDiskUnsignedIndex<IndexInstance>::start(const std::string &tmpPath,
							  unsigned nbThreads,
							  std::vector<unsigned> &cards)
{
  std::string filename = tmpPath + 
    std::string(ToolBox::DirectorySeparatorString) + std::string("revert.tmp");
  FILE *file = fopen(filename.c_str(), "wb");
  if (!file)
    throw ToolBox::FileException("Could not open : " + filename, HERE);

  unsigned docId, descriptorId;
  assert(cards.size() == 0);

  cards.reserve(_mainIndexInstance.getNbElements());
  for (unsigned int i = 0; i < _mainIndexInstance.getNbElements(); ++i)
    {
      docId = i;
      IndexUnsignedIterator it = _mainIndexInstance.getElement(i);
      cards.push_back(it.nbElements());
      const unsigned *sit = it.begin(), *eit = it.end();
      while (sit != eit)
	{
	  descriptorId = *sit;
	  indexWrite(file, docId, descriptorId);	  
	  ++sit;
	}
    }
  fclose(file);
  // Sort without computing frequencies and without removing duplicates
  SortDiskIndex sort(filename, false, false);
  sort.start(tmpPath, nbThreads);
  // We have just to fill the revert index now
  file = fopen(filename.c_str(), "rb");
  if (!file)
    throw ToolBox::FileException("Could not open : " + filename, HERE);
  
  try
    {
      unsigned oldDescriptorId = 0;
      bool firstEntry = true;

      while (!feof(file))
	{
	  indexRead(file, docId, descriptorId);
	  if (firstEntry || descriptorId != oldDescriptorId)
	    {
	      firstEntry = false;
	      if (_revertIndex.addElement() != descriptorId)
		throw ToolBox::Exception("Identifier synchronisation error", 
					 HERE);
	      oldDescriptorId = descriptorId;
	    }
	  _revertIndex.addEntryCurrentElement(docId);
	}
    }
  catch (ToolBox::EOFException &e) {}
  fclose(file);
}

#endif 	    /* !INVERTDISKUNSIGNEDINDEX_HXX_ */
