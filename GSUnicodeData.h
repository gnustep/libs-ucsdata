/*
   Copyright (C) 2001 Free Software Foundation, Inc.

   Written by:  Jonathan Gapen  <jagapen@home.com>
   Date: March 2001

   This file is part of the GNUstep Unicode Character Set Data Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import <Foundation/Foundation.h>
#import "GSUniChar.h"

@interface GSUnicodeData : NSObject
{
  NSMapTable *_ucdEntries;
}

+ (GSUnicodeData *) unicodeData;
+ (GSUnicodeData *) dataWithContentsOfFile: (NSString *)path;

- (id) initWithContentsOfFile: (NSString *)path;

- (GSUniChar *) entryForCharacter: (UTF32Char)ch;
- (NSEnumerator *) objectEnumerator;
@end
