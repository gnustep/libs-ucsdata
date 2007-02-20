#
#  Main Makefile for GNUstep Unicode Character Set Data Library.
#
#  Copyright (C) 2001 Free Software Foundation, Inc.
#
#  Written by:  Jonathan Gapen  <jagapen@home.com>
#
#  This file is part of the GNUstep Unicode Character Set Data Library.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  You should have received a copy of the GNU Library General Public
#  License along with this library; if not, write to the Free
#  Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA
#

ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif

ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to run the GNUstep configuration script before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = libgnustep-ucsdata
libgnustep-ucsdata_OBJC_FILES = GSUnicodeData.m GSUniChar.m
libgnustep-ucsdata_HEADER_FILES = GSUnicodeData.h GSUniChar.h

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/library.make
-include GNUmakefile.postamble
