/*
** ClusteringAlgorithm.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Wed Sep  6 21:30:44 2006 Julien Lemoine
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

#include "ClusteringAlgorithm.h"

#include <set>
#include <algorithm>

#include "Cluster.h"
#include "Cluster.hxx"
#include "IndexUnsignedInstance.h"
#include "IndexUnsignedIterator.h"
#include "SimilarityMeasure.h"

Algo::ClusteringAlgorithm::ClusteringAlgorithm(double threshold,
					       Index::IndexUnsignedInstance &docsIndex,
					       SimilarityMeasure &similarity,
					       unsigned nbClustersMax,
					       bool affectAllIndividuals) :
  _similarity(similarity), _threshold(threshold), _docsIndex(docsIndex),
  _nbClustersMax(nbClustersMax), _nbClusters(0), 
  _affectAllIndividuals(affectAllIndividuals)
{
  _indToCluster.resize(docsIndex.getNbElements(), 0x0);
}

Algo::ClusteringAlgorithm::~ClusteringAlgorithm()
{
  std::set<Cluster*> set;
  std::vector<Cluster*>::const_iterator it, ite = _indToCluster.end();

  for (it = _indToCluster.begin(); it != ite; ++it)
    if (set.find(*it) == set.end())
      {
	delete *it;
	set.insert(*it);
      }
}

struct _cmpClustersBySize
{
  bool operator()(const Algo::Cluster *c1, const Algo::Cluster *c2) const
  {
    if (c1 && c2)
      return c1->cardinal() > c2->cardinal();
    return c1 != 0x0;
  }
};

std::list<const Algo::Cluster*> Algo::ClusteringAlgorithm::finalize()
{
  std::set<Cluster*, _cmpClustersBySize> set;
  std::set<Cluster*, _cmpClustersBySize>::const_iterator sit, site;
  std::vector<Cluster*>::const_iterator it, ite = _indToCluster.end();

  for (it = _indToCluster.begin(); it != ite; ++it)
    if (*it != 0x0 && set.find(*it) == set.end())
      set.insert(*it);
  // Try all object that are not affected to test if there is a
  // cluster when it can enter
  unsigned cnt = 0;
  for (it = _indToCluster.begin(); it != ite; ++it, ++cnt)
    if (*it == 0x0)
      {
	// Individual cnt is not affected
	Cluster c;
	Index::IndexUnsignedIterator it = _docsIndex.getElement(cnt);
	c.addDocument(cnt, it.begin(), it.end());
	// search the maximum similarity with an existing cluster
	double maxSimi = 0;
	Cluster *maxCluster = 0x0;
	for (sit = set.begin(), site = set.end(); sit != site; ++sit)
	  {
	    double currentSimi = _similarity.compute(**sit, c);
	    if (currentSimi > maxSimi)
	      {
		maxSimi = currentSimi;
		maxCluster = *sit;
	      }
	  }
	if (maxCluster && (maxSimi > _threshold || _affectAllIndividuals))
	  { // Add individual in maxCluster
	    maxCluster->addDocument(cnt, it.begin(), it.end());
	    _indToCluster[cnt] = maxCluster;
	  }
      }
  set.clear();
  for (it = _indToCluster.begin(); it != ite; ++it)
    if (*it != 0x0 && set.find(*it) == set.end())
      set.insert(*it);
  std::list<const Cluster*> res;
  for (sit = set.begin(), site = set.end(); sit != site; ++sit)
    res.push_back(*sit);
  return res;
}

double Algo::ClusteringAlgorithm::testMerge(unsigned doc1, unsigned doc2)
{
  if (doc1 >= _indToCluster.size() || doc2 >= _indToCluster.size())
    throw ToolBox::Exception("Invalid Index", HERE);
  bool		createC1 = false;
  bool		createC2 = false;
  Cluster	*c1 = _indToCluster[doc1];
  Cluster	*c2 = _indToCluster[doc2];

  if (!c1 && !c2 && _nbClustersMax > 0 && _nbClustersMax >= _nbClustersMax)
    return 0; // we can not create new cluster, maximum was already found.

  if (!c1)
    {
      createC1 = true;
      c1 = new Cluster();
      ++_nbClusters;
      Index::IndexUnsignedIterator it = _docsIndex.getElement(doc1);
      c1->addDocument(doc1, it.begin(), it.end());
      _indToCluster[doc1] = c1;
    }
  if (!c2)
    {
      createC2 = true;
      c2 = new Cluster();
      ++_nbClusters;
      Index::IndexUnsignedIterator it = _docsIndex.getElement(doc2);
      c2->addDocument(doc2, it.begin(), it.end());
      _indToCluster[doc2] = c2;
    }
  if (c1 == c2)
    return 1;

  double testMerge = _similarity.compute(*c1, *c2);
  // TODO: Test if havind three cluster {c1 - doc1}, {doc1, doc2}, {c2 -
  // doc2} is better than {c1}, {c2} or {c1, c2}
  if (testMerge >= _threshold)
    {
      c1->merge(*c2);
      std::list<unsigned>::const_iterator lit, lite = c2->getDocuments().end();
      for (lit = c2->getDocuments().begin(); lit != lite; ++lit)
	_indToCluster[*lit] = c1;
      --_nbClusters;
      delete c2;
    }
  else if (_nbClustersMax > 0)
    {
      // We must not allow cluster of 1 element count for one cluster
      // when number is limited
      if (createC1)
	{
	  delete c1;
	  --_nbClusters;
	  _indToCluster[doc1] = 0x0;
	}
      if (createC2)
	{
	  delete c2;
	  --_nbClusters;
	  _indToCluster[doc2] = 0x0;
	}
    }
  return testMerge;
}
