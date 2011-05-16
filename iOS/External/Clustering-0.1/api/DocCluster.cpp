/*
** DocCluster.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sun Dec 17 12:02:07 2006 Julien Lemoine
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

#include "DocCluster.h"
#include "Cluster.h"
#include <assert.h>

Clustering::DocClusterIterator::DocClusterIterator(unsigned el, const std::vector<DocCluster*> &v) :
  _el(el), _v(&v)
{
  assert(el <= v.size()); // equal for end iterator
}

Clustering::DocClusterIterator::~DocClusterIterator()
{
}

Clustering::DocClusterIterator& Clustering::DocClusterIterator::operator++()
{
  ++_el;
  return *this;
}

const Clustering::DocCluster& Clustering::DocClusterIterator::operator*() const
{
  assert(_el < _v->size());
  return *(*_v)[_el];
}

const Clustering::DocCluster* Clustering::DocClusterIterator::operator->() const
{
  assert(_el < _v->size());
  return (*_v)[_el];
}

bool Clustering::DocClusterIterator::operator==(const DocClusterIterator &other) const
{
  return _v == other._v && _el == other._el;
}

bool Clustering::DocClusterIterator::operator!=(const DocClusterIterator &other) const
{
  return _v != other._v || _el != other._el;
}

Clustering::DocCluster::DocCluster(const Algo::Cluster &origCluster)
{
  const std::list<unsigned> &docs = origCluster.getDocuments();
  const std::list<Algo::Word> &descs = origCluster.getWords();
   
  _docs.reserve(origCluster.cardinal());
  _descs.reserve(descs.size());

  std::list<unsigned>::const_iterator dit, dite;
  for (dit = docs.begin(), dite = docs.end(); dit != dite; ++dit)
    _docs.push_back(DocId(*dit));
  
  std::list<Algo::Word>::const_iterator wit, wite;
  for (wit = descs.begin(), wite = descs.end(); wit != wite; ++wit)
    _descs.push_back(DescId(wit->wordId, wit->frequency));
}

Clustering::DocCluster::~DocCluster()
{
}

const std::vector<Clustering::DocId>& Clustering::DocCluster::getDocs() const
{
  return _docs;
}

const std::vector<Clustering::DescId>& Clustering::DocCluster::getDescs() const
{
  return _descs;
}

