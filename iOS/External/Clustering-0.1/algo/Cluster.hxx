/*
** Cluster.hxx
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep  4 22:01:36 2006 Julien Lemoine
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

#ifndef   	CLUSTER_HXX_
# define   	CLUSTER_HXX_

#include <algorithm>

namespace Algo
{
  /// template implementation
  template <typename iterator>
  void Cluster::removeDocument(unsigned id, iterator beginWords, iterator endWords)
  {
    std::vector<unsigned> v;
    v.reserve(endWords - beginWords);
    while (beginWords != endWords)
      {
	v.push_back(*beginWords);
	++beginWords;
      }
    std::sort(v.begin(), v.end());

    std::list<Word>::iterator it, ite = _words.end();
    std::vector<unsigned>::const_iterator vit, vite = v.end();
    for (it = _words.begin(), vit = v.begin(); vit != vite; ++vit)
      {
	while (it != ite && it->wordId < *vit)
	  ++it;
	if (it != ite && it->wordId == *vit)
	  --it->frequency;
	else throw ToolBox::Exception("Document not in representative Error", HERE);
      }
    std::list<unsigned>::iterator uit, uite = _documents.end();
    for (uit = _documents.begin(); uit != uite && *uit < id; ++uit) ;
    if (uit != uite && *uit == id)
      _documents.erase(uit);
    else
      throw ToolBox::Exception("Document not in class", HERE);
    --_cardinal;
  }

  template <typename iterator>
  void Cluster::addDocument(unsigned id, iterator beginWords, iterator endWords)
  {
    std::vector<unsigned> v;
    v.reserve(endWords - beginWords);
    while (beginWords != endWords)
      {
	v.push_back(*beginWords);
	++beginWords;
      }
    std::sort(v.begin(), v.end());
    std::list<Word>::iterator it, ite = _words.end();
    std::vector<unsigned>::const_iterator vit, vite = v.end();
    for (it = _words.begin(), vit = v.begin(); vit != vite; ++vit)
      {
	while (it != ite && it->wordId < *vit)
	  ++it;
	if (it != ite && it->wordId == *vit)
	  ++it->frequency;
	else
	  _words.insert(it, Word(*vit, 1));
      }
    std::list<unsigned>::iterator uit, uite = _documents.end();
    for (uit = _documents.begin(); uit != uite && *uit < id; ++uit) ;
    if (uit != uite && *uit == id)
      throw ToolBox::Exception("Document already in class", HERE);
    _documents.insert(uit, id);
    ++_cardinal;
  }
}

#endif	    /* !CLUSTER_HXX_ */
