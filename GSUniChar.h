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

// Sixteen planes of 65536 characters
#define MAX_UNICHAR	(65536*16)

typedef enum
{
  UCDNotAssignedCategory = 0,

  // Normative
  UCDLetterUppercaseCategory,
  UCDLetterLowercaseCategory,
  UCDLetterTitlecaseCategory,
  UCDMarkNonSpacingCategory,
  UCDMarkSpacingCombiningCategory,
  UCDMarkEnclosingCategory,
  UCDNumberDecimalDigitCategory,
  UCDNumberLetterCategory,
  UCDNumberOtherCategory,
  UCDSeparatorSpaceCategory,
  UCDSeparatorLineCategory,
  UCDSeparatorParagraphCategory,
  UCDControlCategory,
  UCDFormatCategory,
  UCDSurrogateCategory,
  UCDPrivateUseCategory,

  // Informative
  UCDLetterModifierCategory,
  UCDLetterOtherCategory,
  UCDPunctuationConnectorCategory,
  UCDPunctuationDashCategory,
  UCDPunctuationOpenCategory,
  UCDPunctuationCloseCategory,
  UCDPunctuationInitialQuoteCategory,
  UCDPunctuationFinalQuoteCategory,
  UCDPunctuationOtherCategory,
  UCDSymbolMathCategory,
  UCDSymbolCurrencyCategory,
  UCDSymbolModifierCategory,
  UCDSymbolOtherCategory
} UCDGeneralCategory;

typedef enum
{
  UCDSpacingCombiningClass,
  UCDOverlaysAndInteriorCombiningClass,
  UCDNuktasCombiningClass,
  // ...and such
} UCDCanonicalCombiningClass;

typedef enum
{
  UCDLeftToRightDirection = 1,
  UCDLeftToRightEmbeddingDirection,
  UCDLeftToRightOverrideDirection,
  UCDRightToLeftDirection,
  UCDRightToLeftArabicDirection,
  UCDRightToLeftEmbeddingDirection,
  UCDRightToLeftOverrideDirection,
  UCDPopDirectionalFormatDirection,
  UCDEuropeanNumberDirection,
  UCDEuropeanNumberSeparatorDirection,
  UCDEuropeanNumberTerminatorDirection,
  UCDArabicNumberDirection,
  UCDCommonNumberSeparatorDirection,
  UCDNonSpacingMarkDirection,
  UCDBoundaryNeutralDirection,
  UCDParagraphSeparatorDirection,
  UCDSegmentSeparatorDirection,
  UCDWhitespaceDirection,
  UCDOtherNeutralsDirection,
} UCDBidirectionalCategory;

@interface GSUniChar : NSObject
{
  UTF32Char		_character;
  NSString		*_name;
  UCDGeneralCategory	_genCat;
  UCDCanonicalCombiningClass	_combiningClass;
  UCDBidirectionalCategory	_biDirCat;
  NSString		*_decomp;
  int			_decimalValue;
  int			_digitValue;
  NSDecimal		_numericValue;
  BOOL			_mirrored;
  NSString		*_oldname;
  NSString		*_comment;
  UTF32Char		_uppercase;
  UTF32Char		_lowercase;
  UTF32Char		_titlecase;
}

- (id) initWithArray: (NSArray *)anArray;
- (id) initWithString: (NSString *)line;

- (UTF32Char) character;
- (NSString *) name;
- (UCDGeneralCategory) generalCategory;
- (UCDCanonicalCombiningClass) canonicalCombiningClass;
- (UCDBidirectionalCategory) bidirectionalCategory;
- (NSString *) decompositionMapping;
- (int) decimalDigitValue;
- (int) digitValue;
- (NSDecimal) numericValue;
- (BOOL) isMirrored;
- (NSString *) oldName;
- (NSString *) comment;
- (UTF32Char) uppercaseMapping;
- (UTF32Char) lowercaseMapping;
- (UTF32Char) titlecaseMapping;

@end
