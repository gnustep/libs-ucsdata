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

#import "GSUnicodeData.h"

@interface _UnicodeDataEnumerator : NSEnumerator
{
  NSMapEnumerator _mapEnumerator;
}

- (id) nextObject;
@end

@implementation _UnicodeDataEnumerator

- (id) initWithMapTable: (NSMapTable *)table
{
  [super init];

  _mapEnumerator = NSEnumerateMapTable(table);

  return self;
}

- (id) nextObject
{
  void *key, *value;

  if (NSNextMapEnumeratorPair(&_mapEnumerator, &key, &value) == YES)
    return (id)value;
  else
    return nil;
}
@end

@implementation GSUnicodeData

+ (GSUnicodeData *) unicodeData
{
  NSArray *paths;
  NSString *path;
  NSEnumerator *enumerator;

  paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                              NSAllDomainsMask, YES);

  enumerator = [paths objectEnumerator];
  while ((path = [enumerator nextObject]))
    {
      path = [NSString pathWithComponents:
        [NSArray arrayWithObjects: path, @"Unicode", @"UnicodeData.txt", nil]];

      if ([[NSFileManager defaultManager] fileExistsAtPath: path])
        {
          return [GSUnicodeData dataWithContentsOfFile: path];
        }
    }

  NSLog(@"ERROR: Unable to locate UnicodeData.txt.");

  return nil;
}

+ (GSUnicodeData *) dataWithContentsOfFile: (NSString *)path
{
  return [[self alloc] initWithContentsOfFile: path];
}

- (id) initWithContentsOfFile: (NSString *)path
{
  NSData *data;
  NSString *dbString, *line;
  NSRange range;
  unsigned stringEnd, lineStart, lineEnd, contentEnd, mapValue;
  GSUniChar *ucdEntry;

  [super init];
  _ucdEntries = NSCreateMapTable(NSIntMapKeyCallBacks,
                                 NSObjectMapValueCallBacks, 65536);

  data = [NSData dataWithContentsOfFile: path];
  if (data == nil)
    {
      [self dealloc];
      return nil;
    }

  dbString = [[NSString alloc] initWithData: data
                                   encoding: NSASCIIStringEncoding];
  if (dbString == nil)
    {
      [self dealloc];
      return nil;
    }

  range = NSMakeRange(0, 1);
  stringEnd = [dbString length];
  do
    {
      NSAutoreleasePool *subpool = [NSAutoreleasePool new];
      [dbString getLineStart: &lineStart
                   end: &lineEnd
           contentsEnd: &contentEnd
              forRange: range];
      line = [dbString substringWithRange:
                         NSMakeRange(lineStart, contentEnd - lineStart)];
      ucdEntry = [[GSUniChar alloc] initWithString: line];
      if (ucdEntry != nil)
        {
          mapValue = (unsigned)[ucdEntry character];
          NSMapInsertKnownAbsent(_ucdEntries, (void *)mapValue, ucdEntry);
        }

      range = NSMakeRange(lineEnd, 1);
      [subpool release];
    }
  while (lineEnd < stringEnd);

  return self;
}

- (void) dealloc
{
  if (_ucdEntries != NULL)
    NSFreeMapTable(_ucdEntries);

  [super dealloc];
}

- (GSUniChar *) entryForCharacter: (unichar)ch
{
  return NSMapGet(_ucdEntries, (void *)((unsigned)ch));
}

- (NSEnumerator *) objectEnumerator
{
  return [[_UnicodeDataEnumerator alloc] initWithMapTable: _ucdEntries];
}

@end
