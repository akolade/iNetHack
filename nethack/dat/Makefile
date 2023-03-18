#
# This file is generated automatically.  Do not edit.
# Your changes will be lost.  See sys/unix/NewInstall.unx.
# Identify this file:
MAKEFILE_DAT=1

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
### Start Makefile.dat
###
#      NetHack Datafiles Makefile.dat $NHDT-Date: 1447844574 2018/04/25 19:25:54 $ $NHDT-Branch: NetHack-3.6.0 $:$NHDT-Revision: 1.22 $
# Copyright (c) 2018 by Pasi Kallinen
# NetHack may be freely redistributed.  See license for details.

# Root of source tree:
NHSROOT=..

# for Atari
# SHELL=E:/GEMINI2/MUPFEL.TTP
# UUDECODE=uudecode

VARDAT = bogusmon data engrave epitaph rumors quest.dat oracles options

all:	$(VARDAT) spec_levs quest_levs dungeon

../util/makedefs:
	(cd ../util ; $(MAKE) makedefs)

../util/dgn_comp:
	(cd ../util ; $(MAKE) dgn_comp)

../util/lev_comp:
	(cd ../util ; $(MAKE) lev_comp)

../util/tile2x11:
	(cd ../util ; $(MAKE) tile2x11)

../util/tile2beos:
	(cd ../util ; $(MAKE) tile2beos)

../util/tile2bmp:
	(cd ../util ; $(MAKE) tile2bmp)

x11tiles: ../util/tile2x11 ../win/share/monsters.txt ../win/share/objects.txt \
				../win/share/other.txt \
                                ../win/share/monsters.txt
	../util/tile2x11 ../win/share/monsters.txt ../win/share/objects.txt \
				../win/share/other.txt \
                                -grayscale ../win/share/monsters.txt

beostiles: ../util/tile2beos ../win/share/monsters.txt \
				../win/share/objects.txt \
				../win/share/other.txt
	../util/tile2beos ../win/share/monsters.txt \
				../win/share/objects.txt \
				../win/share/other.txt

nhtiles.bmp: ../util/tile2bmp ../win/share/monsters.txt \
				../win/share/objects.txt \
				../win/share/other.txt
	../util/tile2bmp $@

NetHack.ad: ../win/X11/NetHack.ad
# handle "#define foo bar" -lines
	grep ^#define ../win/X11/NetHack.ad | \
		sed -e 's/^#define/s/g' -e 's/  */ /g' \
		    -e 's/$$/ g/g' > NetHack.ad.tmp
	grep -v ^#define ../win/X11/NetHack.ad | \
		sed -f NetHack.ad.tmp > NetHack.ad
	-rm -f NetHack.ad.tmp

pet_mark.xbm: ../win/X11/pet_mark.xbm
	cp ../win/X11/pet_mark.xbm pet_mark.xbm

pilemark.xbm: ../win/X11/pilemark.xbm
	cp ../win/X11/pilemark.xbm pilemark.xbm

rip.xpm: ../win/X11/rip.xpm
	cp ../win/X11/rip.xpm rip.xpm

mapbg.xpm: ../win/gnome/mapbg.xpm
	cp ../win/gnome/mapbg.xpm mapbg.xpm

nhsplash.xpm: ../win/Qt/nhsplash.xpm
	cp ../win/Qt/nhsplash.xpm nhsplash.xpm

nethack.icns: ../win/Qt/nhicns.uu
	$(UUDECODE) ../win/Qt/nhicns.uu

Info.plist: ../win/Qt/Info.pli
	cp ../win/Qt/Info.pli Info.plist

../util/tile2img.ttp:
	(cd ../util ; $(MAKE) tile2img.ttp)

../util/xpm2img.ttp:
	(cd ../util ; $(MAKE) xpm2img.ttp)
nh16.img: ../util/tile2img.ttp ../win/share/monsters.txt \
				../win/share/objects.txt ../win/share/other.txt
	../util/tile2img.ttp nh16.img

rip.img: ../util/xpm2img.ttp
	../util/xpm2img.ttp ../win/X11/rip.xpm rip.img
title.img:
	# cp ../win/gem/title.img title.img
	$(UUDECODE) ../win/gem/title.uu

GEM_RSC.RSC:
	# cp ../win/gem/GEM_RSC.RSC GEM_RSC.RSC
	$(UUDECODE) ../win/gem/gem_rsc.uu


data:	data.base ../util/makedefs
	../util/makedefs -d

rumors:	rumors.tru rumors.fal ../util/makedefs
	../util/makedefs -r

quest.dat:	quest.txt ../util/makedefs
	../util/makedefs -q

oracles:	oracles.txt ../util/makedefs
	../util/makedefs -h

engrave:	engrave.txt ../util/makedefs
	../util/makedefs -s

epitaph:	epitaph.txt ../util/makedefs
	../util/makedefs -s

bogusmon:	bogusmon.txt ../util/makedefs
	../util/makedefs -s

# note: 'options' should have already been made when include/date.h was created
options:	../util/makedefs
	../util/makedefs -v


spec_levs: ../util/lev_comp \
	bigroom.des castle.des endgame.des gehennom.des knox.des medusa.des \
	mines.des oracle.des sokoban.des tower.des yendor.des
	../util/lev_comp bigroom.des
	../util/lev_comp castle.des
	../util/lev_comp endgame.des
	../util/lev_comp gehennom.des
	../util/lev_comp knox.des
	../util/lev_comp medusa.des
	../util/lev_comp mines.des
	../util/lev_comp oracle.des
	../util/lev_comp sokoban.des
	../util/lev_comp tower.des
	../util/lev_comp yendor.des
	touch spec_levs

quest_levs: ../util/lev_comp \
	Arch.des Barb.des Caveman.des Healer.des Knight.des Monk.des \
	Priest.des Ranger.des Rogue.des Samurai.des Tourist.des Valkyrie.des \
	Wizard.des
	../util/lev_comp Arch.des
	../util/lev_comp Barb.des
	../util/lev_comp Caveman.des
	../util/lev_comp Healer.des
	../util/lev_comp Knight.des
	../util/lev_comp Monk.des
	../util/lev_comp Priest.des
	../util/lev_comp Ranger.des
	../util/lev_comp Rogue.des
	../util/lev_comp Samurai.des
	../util/lev_comp Tourist.des
	../util/lev_comp Valkyrie.des
	../util/lev_comp Wizard.des
	touch quest_levs

dungeon: dungeon.def ../util/makedefs ../util/dgn_comp
	../util/makedefs -e
	../util/dgn_comp dungeon.pdf

# gitinfo.txt is optionally made by src/Makefile when creating date.h
clean:
	-rm -f gitinfo.txt

spotless: clean
	-rm -f spec_levs quest_levs *.lev $(VARDAT) dungeon dungeon.pdf
	-rm -f nhdat x11tiles beostiles pet_mark.xbm pilemark.xbm rip.xpm mapbg.xpm
	-rm -f rip.img GEM_RSC.RSC title.img nh16.img NetHack.ad
	-rm -f nhsplash.xpm nhtiles.bmp
### End Makefile.dat

###
### Start hints/macosx POST
###
### End hints/macosx POST
