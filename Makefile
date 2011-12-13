#
# Makefile for a Video Disk Recorder plugin
#
# $Id: Makefile,v 1.2 2006/07/05 20:19:56 thomas Exp $

# The official name of this plugin.
# This name will be used in the '-P...' option of VDR to load the plugin.
# By default the main source file also carries this name.
# IMPORTANT: the presence of this macro is important for the Make.config
# file. So it must be defined, even if it is not used here!
#
PLUGIN = dvbapi

### The version number of this plugin (taken from the main source file):

VERSION = $(shell grep 'static const char \*VERSION *=' DVBAPI.cpp | awk '{ print $$6 }' | sed -e 's/[";]//g')

### The C++ compiler and options:

CXX      ?= g++
CXXFLAGS ?= -march=athlon64 -fPIC -O2 -Wall -Woverloaded-virtual

### The directory environment:

VDRDIR = ../../..
LIBDIR = ../../lib
TMPDIR = /tmp

### Make sure that necessary options are included:

-include $(VDRDIR)/Make.global

### Allow user defined options to overwrite defaults:

-include $(VDRDIR)/Make.config

### The version number of VDR's plugin API (taken from VDR's "config.h"):

APIVERSION = $(shell sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$$/\1/p' $(VDRDIR)/config.h)

### The name of the distribution archive:

ARCHIVE = $(PLUGIN)-$(VERSION)
PACKAGE = vdr-$(ARCHIVE)

### Includes and Defines (add further entries here):

INCLUDES += -I$(VDRDIR)/include

DEFINES += -D_GNU_SOURCE -DPLUGIN_NAME_I18N='"$(PLUGIN)"'

### The object files (add further files here):

OBJS = CAPMT.o DeCSA.o DeCsaTSBuffer.o DVBAPI.o SCDeviceProbe.o  SCDVBDevice.o UDPSocket.o SCCIAdapter.o Frame.o SCCAMSlot.o

# FFdeCSA
CPUOPT     ?= native
PARALLEL   ?= PARALLEL_128_SSE2
CSAFLAGS   ?= -O3 -fPIC -fexpensive-optimizations -fomit-frame-pointer -funroll-loops

FFDECSADIR  = FFdecsa
FFDECSA     = $(FFDECSADIR)/FFdecsa.o
FFDECSATEST = $(FFDECSADIR)/FFdecsa_test.done

### The main target:

all: libvdr-$(PLUGIN).so dvbapi_ca.so

### Implicit rules:

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $(DEFINES) $(INCLUDES) $<

### Targets:

libvdr-$(PLUGIN).so: $(OBJS) $(FFDECSA)
	$(CXX) $(CXXFLAGS) -shared $(OBJS) $(FFDECSA) -o $@
	@cp --remove-destination $@ $(LIBDIR)/$@.$(APIVERSION)
	
dvbapi_ca.so: dvbapi_ca.c
	gcc -O -fbuiltin -fomit-frame-pointer -fPIC -shared -o $@ $< -ldl
	
$(FFDECSA): $(FFDECSADIR)/*.c $(FFDECSADIR)/*.h
	@$(MAKE) COMPILER="$(CXX)" FLAGS="$(CSAFLAGS) -march=$(CPUOPT)" PARALLEL_MODE=$(PARALLEL) -C $(FFDECSADIR) all

dist: clean
	@-rm -rf $(TMPDIR)/$(ARCHIVE)
	@mkdir $(TMPDIR)/$(ARCHIVE)
	@cp -a * $(TMPDIR)/$(ARCHIVE)
	@tar czf $(PACKAGE).tgz -C $(TMPDIR) --exclude debian --exclude CVS --exclude .svn $(ARCHIVE)
	@-rm -rf $(TMPDIR)/$(ARCHIVE)
	@echo Distribution package created as $(PACKAGE).tgz

clean:
	@-rm -f $(PODIR)/*.mo $(PODIR)/*.pot
	@-rm -f $(OBJS)  $(DEPFILE) *.so *.tgz core* *~ $(PODIR)/*.mo $(PODIR)/*.pot
	@$(MAKE) -C $(FFDECSADIR) clean
