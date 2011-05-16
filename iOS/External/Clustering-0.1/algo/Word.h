/*
** Word.h
** Login : Julien Lemoine <speedblue@happycoders.org>
** Started on  Sat Sep 16 19:53:17 2006 Julien Lemoine
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

#ifndef   	WORD_H_
# define   	WORD_H_

namespace Algo
{
  /// represent the number of document who have a specific word
  class Word
  {
  public:
    /// constructor
    Word(unsigned id, unsigned freq);
    
  private:
    /// avoid default constructor
    Word();

  public:
    /// id of word
    unsigned wordId;
    /// number of documents who have this word
    unsigned frequency;
  };
}

#endif 	    /* !WORD_H_ */
