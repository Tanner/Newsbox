/*
** PairArticles.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep 18 22:07:18 2006 Julien Lemoine
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

#include "PairArticles.h"
#include <cmath>
#include <iostream>

Algo::PairArticles::PairArticles(unsigned firstArticle, unsigned secondArticle,
				 double score) :
  first(firstArticle), second(secondArticle), similarity(score)
{
}

Algo::SortPairsArticles::SortPairsArticles(const std::vector<unsigned> &cards) :
  _cards(cards)
{
}

bool Algo::SortPairsArticles::operator()(const PairArticles &p1, const PairArticles &p2)
{
  double diff = fabs(p1.similarity - p2.similarity);
  if (diff > 1e-3)
    return p1.similarity > p2.similarity;
  // score are equals. Now give a better score to articles wich have
  // quite the same size
  unsigned cdiff1 = abs(_cards[p1.first] - _cards[p1.second]);
  unsigned cdiff2 = abs(_cards[p2.first] - _cards[p2.second]);
  return cdiff1 < cdiff2;
}
