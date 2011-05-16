/*
** Results.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Dec 17 12:04:09 2006 Julien Lemoine
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

#include "Results.h"
#include <assert.h>
#include "Cluster.h"

Clustering::Results::Results(const std::list<const Algo::Cluster*> &clusters)
{
  _clusters.reserve(clusters.size());
  std::list<const Algo::Cluster*>::const_iterator cit, cite;
  for (cit = clusters.begin(), cite = clusters.end(); cit != cite; ++cit)
    {
      assert(*cit != 0x0);
      _clusters.push_back(new DocCluster(**cit));
    }
}

Clustering::Results::~Results()
{
  for (unsigned int i = 0; i < _clusters.size(); ++i)
    delete _clusters[i];
}

Clustering::DocClusterIterator Clustering::Results::begin() const
{
  return DocClusterIterator(0, _clusters);
}

Clustering::DocClusterIterator Clustering::Results::end() const
{
  return DocClusterIterator(_clusters.size(), _clusters);
}

