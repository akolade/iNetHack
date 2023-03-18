#
# This file is generated automatically.  Do not edit.
# Your changes will be lost.  See sys/unix/NewInstall.unx.
# Identify this file:
MAKEFILE_DOC=1

###
### Start hints/macosx PRE
###
# (new segment at source line 6 )
# Mac OS X (Darwin) hints file
# This is for Mac OS X 10.4 (Darwin 8.10).  Use one of the more specific
# hints files for later versions.
# Useful info: http://www.opensource.apple.com/darwinsource/index.html

# This hints file can build several different types of installations.
# Edit the next section to match the type of build you need.

# 1. Which window system(s) should be included in this binary?
WANT_WIN_TTY=1
#WANT_WIN_X11=1
#WANT_WIN_QT=1

# 1a. What is the default window system?
WANT_DEFAULT=tty
#WANT_DEFAULT=x11
#WANT_DEFAULT=qt

# 1b. If you set WANT_WIN_QT, you need to
#  A) set QTDIR either here or in the environment to point to the Qt2 or Qt3
#     library installation root.  (Qt4 will not work; Qt3 does not presently
#     compile under Leopard (MacOSX 10.5) out-of-the-box.)
#  B) set XPMLIB to point to the Xpm library
ifdef WANT_WIN_QT
QTDIR=/Developer/Qt
LIBXPM= -L/Developer/SDKs/MacOSX10.3.9.sdk/usr/X11R6/lib -lXpm
endif

# 2. Is this a build for a binary that will be shared among different users
#    or will it be private to you?
#    If it is shared:
#	- it will be owned by the user and group listed
#	- you MUST create the user using System Preferences (this will also
#	  create the group if it is the same as the user)
#	- 'make install' must be run as "sudo make install"    
#WANT_SHARE_INSTALL=1
GAMEUID  = games
GAMEGRP  = $(GAMEUID)


#CC=gcc -W -Wimplicit -Wreturn-type -Wunused -Wformat -Wswitch -Wshadow -Wcast-qual -Wwrite-strings -DGCC_WARN
CC=gcc -Wall -Wextra -Wno-missing-field-initializers -Wimplicit -Wreturn-type -Wunused -Wformat -Wswitch -Wshadow -Wwrite-strings -DGCC_WARN

#
# You shouldn't need to change anything below here.
#

# XXX -g vs -O should go here, -I../include goes in the makefile
CFLAGS=-g -I../include
CFLAGS+=-DNOCLIPPING -DNOMAIL -DNOTPARMDECL -DHACKDIR=\"$(HACKDIR)\"
CFLAGS+= -DDEFAULT_WINDOW_SYS=\"$(WANT_DEFAULT)\" -DDLB

ifdef WANT_WIN_TTY
WINSRC = $(WINTTYSRC)
WINOBJ = $(WINTTYOBJ)
WINLIB = $(WINTTYLIB)
WINTTYLIB=-lncurses
else
CFLAGS += -DNOTTYGRAPHICS
endif

ifdef WANT_WIN_X11
WINSRC += $(WINX11SRC)
WINOBJ += $(WINX11OBJ)
WINLIB += $(WINX11LIB)
LFLAGS=-L/usr/X11R6/lib
VARDATND = x11tiles NetHack.ad pet_mark.xbm pilemark.xbm
POSTINSTALL= bdftopcf win/X11/nh10.bdf > $(INSTDIR)/nh10.pcf; ( cd $(INSTDIR); mkfontdir -x .lev )
CFLAGS += -DX11_GRAPHICS
endif

ifdef WANT_WIN_QT
CFLAGS += -DQT_GRAPHICS -DNOUSER_SOUNDS
CFLAGS += -isysroot /Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4
LINK=g++
WINSRC += $(WINQTSRC)
WINLIB += $(WINQTLIB) $(LIBXPM)
WINLIB += -framework Carbon -framework QuickTime -lz -framework OpenGL
WINLIB += -framework AGL
ifdef WANT_WIN_X11
	# prevent duplicate tile.o in WINOBJ
WINOBJ = $(sort $(WINQTOBJ) $(WINX11OBJ))
ifdef WANT_WIN_TTY
WINOBJ += $(WINTTYOBJ)
endif
else
WINOBJ += $(WINQTOBJ)
endif
# XXX if /Developer/qt exists and QTDIR not set, use that
ifndef QTDIR
$(error QTDIR not defined in the environment or Makefile)
endif
# XXX make sure QTDIR points to something reasonable
else
LINK=$(CC)
endif

ifdef WANT_SHARE_INSTALL
# NB: do NOT use $(wildcard ~$(GAMEUID)) since the user may not exist yet.
PREFIX:=/Users/$(GAMEUID)
SHELLDIR=$(PREFIX)/bin
HACKDIR=$(PREFIX)/nethackdir
INSTDIR=$(HACKDIR)
VARDIR=$(HACKDIR)
CHOWN=chown
CHGRP=chgrp
# We run sgid so the game has access to both HACKDIR and user preferences.
GAMEPERM = 02755
VARFILEPERM = 0664
VARDIRPERM = 0775
ROOTCHECK= [[ `id -u` == 0 ]] || ( echo "Must run install with sudo."; exit 1)
# make sure we have group GAMEUID and group GAMEGRP
PREINSTALL= . sys/unix/hints/macosx.sh user $(GAMEUID); . sys/unix/hints/macosx.sh group $(GAMEGRP); mkdir $(SHELLDIR); chown $(GAMEUID) $(SHELLDIR)
POSTINSTALL= touch $(INSTDIR)/sysconf; $(CHOWN) $(GAMEUID) $(INSTDIR)/sysconf; $(CHGRP) $(GAMEGRP) $(INSTDIR)/sysconf; chmod $(VARFILEPERM) $(INSTDIR)/sysconf
CFLAGS+=-DSYSCF -DSYSCF_FILE=\"$(HACKDIR)/sysconf\" -DSECURE
else
PREFIX:=$(wildcard ~)
SHELLDIR=$(PREFIX)/bin
HACKDIR=$(PREFIX)/nethackdir
INSTDIR=$(HACKDIR)
VARDIR=$(HACKDIR)
CHOWN=true
CHGRP=true
GAMEPERM = 0700
VARFILEPERM = 0600
VARDIRPERM = 0700
ifdef WANT_WIN_X11
# XXX install nethack.rc as ~/.nethackrc if no ~/.nethackrc exists
endif
endif


# ~/Library/Preferences/NetHack Defaults
# OPTIONS=name:player,number_pad,menustyle:partial,!time,showexp
# OPTIONS=hilite_pet,toptenwin,msghistory:200,windowtype:Qt
#
# Install.Qt mentions a patch for macos - it's not there (it seems to be in the Qt binary
# package under the docs directory).
### End hints/macosx PRE

###
### Start Makefile.doc
###
#      NetHack Documentation Makefile.
# NetHack 3.6  Makefile.doc    $NHDT-Date: 1581732920 2020/02/15 02:15:20 $  $NHDT-Branch: NetHack-3.7 $:$NHDT-Revision: 1.20 $
# Copyright (c) 2015 by Kenneth Lorber, Kensington, Maryland
# NetHack may be freely redistributed.  See license for details.

# Root of source tree:
NHSROOT=..

# for Atari
# SHELL=E:/GEMINI2/MUPFEL.TTP

MAKEDEFS = ../util/makedefs

# Which version do we want to build?  (XXX These are not used anywhere.)
GUIDEBOOK = Guidebook		# regular ASCII file
#GUIDEBOOK = Guidebook.ps	# PostScript file
#GUIDEBOOK = Guidebook.dvi	# TeX device-independent file

# Some versions of col need -x to keep them from converting spaces to tabs;
# some versions of col don't do the conversion by default and don't
# recognize the option.  Sigh.
COLCMD = col -bx
#COLCMD = col -b

# The command to use to generate a PostScript file
# PSCMD = ditroff | psdit
PSCMD = groff

# Use the "cat" GUIDECMD if nroff and/or tbl and/or col are not installed
# Not appropriate for creating Guidebook.txt.
# GUIDECMD = cat Guidebook.txt
#
# Single page. Might need adjustment to .pl value
# GUIDECMD= $(GUIDE_PREFORMAT) | perl -pe 's/^(.mt)$$/.pl 4720v\n.in 0\n.po 8\n.ll 64m\n$$1/' | nroff -c -Tascii | $(COLCMD)
#
GUIDECMD = $(GUIDE_PREFORMAT) | nroff -c -Tascii | $(COLCMD)
ONEPAGECMD = $(ONEPAGE_PREFORMAT) | nroff -c -Tascii | $(COLCMD) \
	| sed -e '/EOF--EOF/,12345D'

# Only generate output for the current configuration:
NHGREP = $(MAKEDEFS) --grep --input - --output -
# Generate output for all configurations:
#NHGREP = $(MAKEDEFS) --grep --input - --output - --grep-define ALLDOCS
# Fallback:
#NHGREP = cat

GUIDE_PREFORMAT = cat Guidebook.mn | $(NHGREP) | tbl tmac.n -
# for Guidebook.dat, unpaginated version of Guidebook.txt
ONEPAGE_PREFORMAT = cat Gbk-1pg-pfx.mn Guidebook.mn Gbk-1pg-sfx.mn \
	| $(NHGREP) | tbl tmac.n -

# the basic guidebook
Guidebook:	Guidebook.mn tmac.n tmac.nh
	$(GUIDECMD) > Guidebook

# Fancier output for those with ditroff, psdit and a PostScript printer.
Guidebook.ps:	Guidebook.mn tmac.n tmac.nh
	$(GUIDE_PREFORMAT) | $(PSCMD) > Guidebook.ps

# Guidebook.tex is the same as Guidebook.mn but formatted with LaTeX.
# - The invocation command for LaTeX may vary in different installations.
# - To print Guidebook.dvi you need to use a suitable dvi-driver.
# - LaTeX needs to be run twice; second pass uses Guidebook.aux made by first.
Guidebook.dvi:	Guidebook.tex
	latex Guidebook.tex
	latex Guidebook.tex


GAME	= nethack
MANDIR	= /usr/man/man6
MANEXT	= 6

# manual installation for most BSD-style systems
GAMEMANCREATE = cat nethack.6 | $(NHGREP) >
LEVMANCREATE = cat lev_comp.6 | $(NHGREP) >
DGNMANCREATE = cat dgn_comp.6 | $(NHGREP) >
RCVRMANCREATE = cat recover.6 | $(NHGREP) >
DLBMANCREATE = cat dlb.6 | $(NHGREP) >
MDMANCREATE = cat makedefs.6 | $(NHGREP) >
# manual installation for most SYSV-style systems
# GAMEMANCREATE = cat nethack.6 | $(NHGREP) | nroff -man - >
# LEVMANCREATE = cat lev_comp.6 | $(NHGREP) | nroff -man - >
# DGNMANCREATE = cat dgn_comp.6 | $(NHGREP) | nroff -man - >
# RCVRMANCREATE = cat recover.6 | $(NHGREP) | nroff -man - >
# DLBMANCREATE = cat dlb.6 | $(NHGREP) | nroff -man - >
# MDMANCREATE = cat makedefs.6 | $(NHGREP) | nroff -man - >

manpages:
	-$(GAMEMANCREATE) $(MANDIR)/$(GAME).$(MANEXT)
	-$(LEVMANCREATE) $(MANDIR)/lev_comp.$(MANEXT)
	-$(DGNMANCREATE) $(MANDIR)/dgn_comp.$(MANEXT)
	-$(RCVRMANCREATE) $(MANDIR)/recover.$(MANEXT)
	-$(DLBMANCREATE) $(MANDIR)/dlb.$(MANEXT)
	-$(MDMANCREATE) $(MANDIR)/makedefs.$(MANEXT)

# manual creation for distribution
DISTRIB = Guidebook.txt nethack.txt lev_comp.txt dgn_comp.txt recover.txt \
	dlb.txt makedefs.txt

distrib: $(DISTRIB)
	@echo "Plain text documentation is up to date."

Guidebook.txt	: Guidebook.mn tmac.n tmac.nh
	$(GUIDECMD) > Guidebook.txt
Guidebook.dat	: Gbk-1pg-pfx.mn Gbk-1pg-sfx.mn Guidebook.mn tmac.n tmac.nh
	$(ONEPAGECMD) > Guidebook.dat

MAN2TXT = $(NHGREP) | nroff -man - | $(COLCMD)
nethack.txt	: nethack.6
	cat nethack.6 | $(MAN2TXT) > nethack.txt
lev_comp.txt	: lev_comp.6
	cat lev_comp.6 | $(MAN2TXT) > lev_comp.txt
dgn_comp.txt	: dgn_comp.6
	cat dgn_comp.6 | $(MAN2TXT) > dgn_comp.txt
recover.txt	: recover.6
	cat recover.6 | $(MAN2TXT) > recover.txt
dlb.txt		: dlb.6
	cat dlb.6 | $(MAN2TXT) > dlb.txt
makedefs.txt		: makedefs.6
	cat makedefs.6 | $(MAN2TXT) > makedefs.txt

clean:
	-rm -f Guidebook.aux Guidebook.log

spotless: clean
	-rm -f Guidebook Guidebook.dat Guidebook.ps Guidebook.dvi

maintainer-clean: spotless
	-rm -f $(DISTRIB)
#	-rm -f Makefile
### End Makefile.doc

###
### Start hints/macosx POST
###
### End hints/macosx POST
