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

#import "GSUniChar.h"

#define NUM_CATEGORIES	((int)(UCDSymbolOtherCategory))

struct UCDCategoryMap
{
  NSString *categoryString;
  UCDGeneralCategory category;
};

struct UCDCategoryMap categoryMap[NUM_CATEGORIES] = {
  { @"Lo", UCDLetterOtherCategory },      //  5228 chars
  { @"So", UCDSymbolOtherCategory },      //  2005 chars
  { @"Ll", UCDLetterLowercaseCategory },  //  840 chars
  { @"Lu", UCDLetterUppercaseCategory },  //  686 chars
  { @"Mn", UCDMarkNonSpacingCategory },   //  447 chars
  { @"Sm", UCDSymbolMathCategory },       //  299 chars
  { @"Nd", UCDNumberDecimalDigitCategory },   // 198 chars
  { @"No", UCDNumberOtherCategory },      //  186 chars
  { @"Po", UCDPunctuationOtherCategory }, //  185 chars
  { @"Mc", UCDMarkSpacingCombiningCategory }, // 118 chars
  { @"Sk", UCDSymbolModifierCategory },   //  69 chars
  { @"Cc", UCDControlCategory },          //  65 chars
  { @"Nl", UCDNumberLetterCategory },     //  49 chars
  { @"Lm", UCDLetterModifierCategory },   //  46 chars
  { @"Ps", UCDPunctuationOpenCategory },  //  39 chars
  { @"Pe", UCDPunctuationCloseCategory }, //  37 chars
  { @"Lt", UCDLetterTitlecaseCategory },  //  31 chars
  { @"Sc", UCDSymbolCurrencyCategory },   //  31 chars
  { @"Cf", UCDFormatCategory },           //  24 chars
  { @"Pd", UCDPunctuationDashCategory },  //  17 chars
  { @"Zs", UCDSeparatorSpaceCategory },   //  17 chars
  { @"Pc", UCDPunctuationConnectorCategory }, //  11 chars
  { @"Me", UCDMarkEnclosingCategory },    //  10 chars
  { @"Pi", UCDPunctuationInitialQuoteCategory }, //  6 chars
  { @"Co", UCDPrivateUseCategory },       //  6 chars
  { @"Cs", UCDSurrogateCategory },        //  6 chars
  { @"Pf", UCDPunctuationFinalQuoteCategory },   //  4 chars
  { @"Zl", UCDSeparatorLineCategory },    //  1 char
  { @"Zp", UCDSeparatorParagraphCategory },   //  1 char
};

@implementation GSUniChar

- (id) initWithArray: (NSArray *)anArray
{
  NSScanner *scanner;
  unsigned unsignedValue;
  NSString *genCatStr, *aString;
  int i;

  [super init];

  // character value
  scanner = [NSScanner scannerWithString: [anArray objectAtIndex: 0]];
  [scanner scanHexInt: &unsignedValue];
  if (unsignedValue < MAX_UNICHAR)
    _character = unsignedValue;
  else
    {
      // NSLog(@"Found character value %x", unsignedValue);
      [self dealloc];
      return nil;
    }

  // name
  _name = [[anArray objectAtIndex: 1] retain];

  // general category
  _genCat = UCDNotAssignedCategory;
  genCatStr = [anArray objectAtIndex: 2];

  for (i = 0; i < NUM_CATEGORIES; i++)
    {
      if ([genCatStr isEqualToString: categoryMap[i].categoryString])
        {
          _genCat = categoryMap[i].category;
          break;
        }
    }

  // combining classes
  // FIXME - implement

  // bidirectional category
  // FIXME - implement
  _biDirCat = 0;

  // decomposition mapping
  _decomp = [[anArray objectAtIndex: 5] retain];

  // decimal digit value
  aString = [anArray objectAtIndex: 6];
  if (aString != nil)
    {
      // NSString's intValue returns 0 if the receiver doesn't contain
      // a decimal integer value, but 0 is a valid decimal digit.
      scanner = [NSScanner scannerWithString: aString];
      if ([scanner scanInt: &_decimalValue] == NO)
        _decimalValue = -1;
    }

  // digit value
  aString = [anArray objectAtIndex: 7];
  if (aString != nil)
    {
      scanner = [NSScanner scannerWithString: aString];
      if ([scanner scanInt: &_digitValue] == NO)
        _digitValue = -1;
    }

  // numeric value

  // mirrored
  if ([[anArray objectAtIndex: 9] isEqualToString: @"Y"])
    _mirrored = YES;
  else
    _mirrored = NO;

  // Unicode 1.0 name
  _oldname = [[anArray objectAtIndex: 10] retain];

  // 10646 comment field
  _comment = [[anArray objectAtIndex: 11] retain];

  // uppercase mapping
  _uppercase = unsignedValue = 0;
  aString = [anArray objectAtIndex: 12];
  if (aString != nil)
    {
      scanner = [NSScanner scannerWithString: aString];
      [scanner scanHexInt: &unsignedValue];
      if (unsignedValue < MAX_UNICHAR)
        _uppercase = (unichar)unsignedValue;
    }

  // lowercase mapping
  _lowercase = unsignedValue = 0;
  aString = [anArray objectAtIndex: 13];
  if (aString != nil)
    {
      scanner = [NSScanner scannerWithString: aString];
      [scanner scanHexInt: &unsignedValue];
      if (unsignedValue < MAX_UNICHAR)
        _lowercase = (unichar)unsignedValue;
    }

  // titlecase mapping
  _titlecase = unsignedValue = 0;
  aString = [anArray objectAtIndex: 14];
  if (aString != nil)                  
    {               
      scanner = [NSScanner scannerWithString: aString];
      [scanner scanHexInt: &unsignedValue];
      if (unsignedValue < MAX_UNICHAR)
        _titlecase = (unichar)unsignedValue;
    }

  return self;
}

- (id) initWithString: (NSString *)line
{
  NSArray *fields = [line componentsSeparatedByString:@";"];

  return [self initWithArray: fields];
}

- (void) dealloc
{
  if (_name)
    [_name release];
  if (_decomp)
    [_decomp release];

  [super dealloc];
}

- (unichar) character
{
  return _character;
}

- (NSString *) name
{
  return _name;
}

- (UCDGeneralCategory) generalCategory
{
  return _genCat;
}

- (UCDCanonicalCombiningClass) canonicalCombiningClass
{
  return _combiningClass;
}

- (UCDBidirectionalCategory) bidirectionalCategory
{
  return _biDirCat;
}

- (NSString *) decompositionMapping
{
  return _decomp;
}

- (int) decimalDigitValue
{
  return _decimalValue;
}

- (int) digitValue
{
  return _digitValue;
}

- (NSDecimal) numericValue
{
  return _numericValue;
}

- (BOOL) isMirrored
{
  return _mirrored;
}

- (NSString *) oldName
{
  return _oldname;
}

- (NSString *) comment
{
  return _comment;
}

- (unichar) uppercaseMapping
{
  return _uppercase;
}

- (unichar) lowercaseMapping
{
  return _lowercase;
}

- (unichar) titlecaseMapping
{
  return _titlecase;
}

@end
