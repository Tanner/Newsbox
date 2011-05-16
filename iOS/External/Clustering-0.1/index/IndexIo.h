/*
** IndexIo.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep 13 22:10:08 2006 Julien Lemoine
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

#ifndef   	INDEXIO_H_
# define   	INDEXIO_H_

#include <stdio.h>

namespace Index
{
  /**
   * @brief read doc and descriptor Ids from input file
   */
  void indexRead(FILE *file, unsigned &docId, unsigned &descriptorId);
  /**
   * @brief write doc and descriptor Ids to input file
   */
  void indexWrite(FILE *file, unsigned docId, unsigned descriptorId);
}

#endif 	    /* !INDEXIO_H_ */
