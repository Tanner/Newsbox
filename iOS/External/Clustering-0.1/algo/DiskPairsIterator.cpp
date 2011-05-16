/*
** DiskPairsIterator.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Sep 24 17:10:11 2006 Julien Lemoine
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

#include <iostream>
#include "DiskPairsIterator.h"
#include "Exception.h"
#include "ports.h"

Algo::DiskPairsIterator::DiskPairsIterator(const std::string &file, bool deleteFile) :
  PairsIterator(), _delete(deleteFile), _filename(file), _fd(0x0), _current(0, 0, 0)
{
  _fd = fopen(file.c_str(), "rb");
  if (!_fd)
    throw ToolBox::Exception("Could not open : " + file, HERE);
  ++(*this); // read one element
}

Algo::DiskPairsIterator::~DiskPairsIterator()
{
  if (_fd)
    fclose(_fd);
  _fd = 0x0;
  if (_delete)
    ToolBox::unlink(_filename.c_str());
}

bool Algo::DiskPairsIterator::isEnd() const
{
  return feof(_fd);
}

Algo::PairsIterator& Algo::DiskPairsIterator::operator++()
{
  if (isEnd())
    throw ToolBox::Exception("EOF", HERE);
  fread(&_current, sizeof(PairArticles), 1, _fd);
  return *this;
}

const Algo::PairArticles& Algo::DiskPairsIterator::operator*() const
{
  return _current;
}

const Algo::PairArticles* Algo::DiskPairsIterator::operator->() const
{
  return &_current;
}
