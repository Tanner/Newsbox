/*
** DiskIndexUnsignedInstance.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep 13 22:00:23 2006 Julien Lemoine
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

#include "DiskIndexUnsignedInstance.h"
#include "IndexUnsignedIterator.h"

Index::DiskIndexUnsignedInstance::DiskIndexUnsignedInstance(const DiskIndexUnsignedData &data) :
  IndexUnsignedInstance(), _data(data), _cache(0x0)
{
  _cacheSize = 32768;
  _cache = new unsigned[_cacheSize];
}

Index::DiskIndexUnsignedInstance::~DiskIndexUnsignedInstance()
{
  if (_cache)
    delete[] _cache;
}

Index::IndexUnsignedIterator Index::DiskIndexUnsignedInstance::getElement(unsigned id) const
{
  return _data._getElement(id, _cache, _cacheSize);
}

unsigned Index::DiskIndexUnsignedInstance::getNbElements() const
{
  return _data.getNbElements();
}
