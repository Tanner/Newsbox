/*
** IndexIo.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep 13 23:12:08 2006 Julien Lemoine
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


#include "IndexIo.h"
#include "Exception.h"

void Index::indexRead(FILE *file, unsigned &docId, unsigned &descriptorId)
{
  if (fread(&docId, sizeof(unsigned), 1, file) != 1)
    throw ToolBox::EOFException("EOF", HERE);
  if (fread(&descriptorId, sizeof(unsigned), 1, file) != 1)
    throw ToolBox::FileException("read error", HERE);
}

void Index::indexWrite(FILE *file, unsigned docId, unsigned descriptorId)
{
  if (fwrite(&docId, sizeof(unsigned), 1, file) != 1)
    throw ToolBox::FileException("write error", HERE);
  if (fwrite(&descriptorId, sizeof(unsigned), 1, file) != 1)
    throw ToolBox::FileException("write error", HERE);
}

