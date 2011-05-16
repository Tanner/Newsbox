/*
** SortDiskIndex.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Dec 27 21:48:01 2006 Julien Lemoine
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

#ifndef   	SORTDISKINDEX_H_
# define   	SORTDISKINDEX_H_

#include "SortFile.hxx"
#include "SortFileThread.hxx"
#include "SortDiskIndexBloc.h"
#include "SortDiskIndexCopy.h"
#include "SortDiskIndexFileAccess.h"

namespace Index
{
  /**
   * We are storing index entry as a pair on disk, first element of pair is
   * the documentId and the second element of pair is the descriptor id.
   * 
   * Class SortDiskIndexBloc implements the read of a bloc of index pairs in memory
   * with a bloc allocation (will not allocate one element for each pair)
   * 
   * SortDiskIndexFileAccess is a binding for method in io.h, it implement
   * read/write in a file.
   * 
   * SortDiskIndexCopy implements the copy of a pair and the equal
   * comparator in order to count frequencies
   */
  typedef ToolBox::SortFile<std::pair<unsigned, unsigned>, 
			    SortDiskIndexBloc,
			    SortDiskIndexFileAccess,
			    SortDiskIndexCopy> SortDiskIndex;
}

#endif 	    /* !SORTDISKINDEX_H_ */
