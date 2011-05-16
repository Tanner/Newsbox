/*
** Cluster.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep  4 21:59:04 2006 Julien Lemoine
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

#include "Cluster.h"
#include <iostream>

Algo::Cluster::Cluster() :
  _cardinal(0)
{
}

Algo::Cluster::~Cluster()
{
}

std::list<unsigned>& Algo::Cluster::_getDocuments()
{
  return _documents;
}

const std::list<unsigned>& Algo::Cluster::getDocuments() const
{
  return _documents;
}

const std::list<Algo::Word>& Algo::Cluster::getWords() const
{
  return _words;
}

void Algo::Cluster::display(std::ostream &os) const
{
  std::list<unsigned>::const_iterator dit, dite = _documents.end();
  for (dit = _documents.begin(); dit != dite; ++dit)
    os << "[" << *dit << "]";
  os << std::endl;
}

void Algo::Cluster::check() const
{
  unsigned previous = 0;
  std::list<unsigned>::const_iterator dit, dite = _documents.end();
  for (dit = _documents.begin(); dit != dite; ++dit)
    {
      if (*dit < previous)
	throw ToolBox::Exception("Invalid list of documents", HERE);
      previous = *dit;
    }
  previous = 0;
  std::list<Word>::const_iterator wit, wite = _words.end();
  for (wit = _words.begin(); wit != wite; ++wit)
    {
      if (wit->wordId < previous)
	throw ToolBox::Exception("Invalid list of word", HERE);
      if (!wit->frequency)
	throw ToolBox::Exception("Invalid list of word", HERE);
      previous = wit->wordId;
    }
}

void Algo::Cluster::merge(const Cluster &other)
{
   // Compute the first part : dot product between two clusters
  std::list<Word>::iterator wc1, wc1e = _words.end();
  std::list<Word>::const_iterator wc2, wc2e = other._words.end();

  for (wc1 = _words.begin(), wc2 = other._words.begin(); wc2 != wc2e; )
    {
      if (wc1 == _words.end())
	{
	  _words.push_back(*wc2);
	  ++wc2;
	}
      else if (wc1->wordId < wc2->wordId)
	++wc1;
      else if (wc2->wordId < wc1->wordId)
	{
	  _words.insert(wc1, *wc2);
	  ++wc2;
	}
      else // equal
	{
	  wc1->frequency += wc2->frequency;
	  ++wc1;
	  ++wc2;
	}
    }
  
  std::list<unsigned>::iterator dc1, dc1e = _documents.end();
  std::list<unsigned>::const_iterator dc2, dc2e = other._documents.end();
  // Assume that two list of individuals are sorted
  for (dc1 = _documents.begin(), dc2 = other._documents.begin(); dc2 != dc2e; )
    {
      if (dc1 == dc1e)
	{
	  _documents.push_back(*dc2);
	  ++dc2;
	}
      else if (*dc1 < *dc2)
	++dc1;
      else if (*dc2 < *dc1)
	{
	  _documents.insert(dc1, *dc2);
	  ++dc2;
	}
      else
	throw ToolBox::Exception("Same document in two clusters", HERE);
    }
  _cardinal += other._cardinal;
}

unsigned Algo::Cluster::cardinal() const
{
  return _cardinal;
}

