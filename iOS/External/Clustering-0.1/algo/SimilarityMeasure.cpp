/*
** SimilarityMeasure.cpp
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 20:00:03 2006 Julien Lemoine
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

#include "SimilarityMeasure.h"
#include "Exception.h"

Algo::SimilarityMeasure::SimilarityMeasure(const std::vector<unsigned> &docCards,
					   unsigned nbDescriptors) :
  _docCards(docCards), _nbDescriptors(nbDescriptors)
{
}

Algo::SimilarityMeasure::~SimilarityMeasure()
{
}

unsigned Algo::SimilarityMeasure::_getDocCard(unsigned docId) const
{
  if (docId >= _docCards.size())
    {
      std::cout << docId << "/" << _docCards.size() << std::endl;
      throw ToolBox::Exception("Invalid Document ID", HERE);
    }
  return _docCards[docId];
}

unsigned Algo::SimilarityMeasure::_getNbDescriptors() const
{
  return _nbDescriptors;
}
