/*
** PairArticles.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Mon Sep 18 22:06:19 2006 Julien Lemoine
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

#ifndef   	PAIRARTICLES_H_
# define   	PAIRARTICLES_H_

#include <vector>

namespace Algo
{
  /**
   * @brief class that represents a pair of document with their
   * similarity
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class PairArticles
    {
    public:
      PairArticles(unsigned firstArticle, unsigned secondArticle,
		   double score);

    private:
      /// avoid default constructor
      PairArticles();

    public:
      /// first article id
      unsigned	first;
      /// second article id
      unsigned	second;
      /// similarity between first and second document
      double	similarity;
    };

  /**
   * @brief class that sort a vector of PairsArticle according to their
   * similarity and if they are similar their cardinals
   * @author Julien Lemoine <speedblue@happycoders.org>
   */
  class SortPairsArticles
    {
    public:
      SortPairsArticles(const std::vector<unsigned> &cards);
  
    public:
      /// comparison operator
      bool operator()(const PairArticles &p1, const PairArticles &p2);

    private:
      /// cardinals
      const std::vector<unsigned>	&_cards;
    };
}

#endif 	    /* !PAIRARTICLES_H_ */
