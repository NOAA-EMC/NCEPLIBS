# libsrc/Makefile.  Generated from Makefile.in by configure.

# libsrc/ level makefile template

# Package-specific substitution variables
package = CRTM
version = v2.2.3
tarname = crtm
distdir = $(tarname)_$(version)

# Prefix-specific substitution variables
prefix = /usr/local

# Mixed package and prefix substitution variables
installdir = $(prefix)/$(distdir)

# Tool-specific substitution variables
FC      = ifort
#FCFLAGS = -assume byterecl -convert big_endian -g -FR -c
FCFLAGS = -assume byterecl -convert big_endian -O3 -fp-model source -free -c 
AR      = ar
ARFLAGS = crvs
RANLIB  = ranlib
INSTALL      = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644

# The library name
LIBRARY = lib$(tarname).a

# The file definitions. This include must occur before targets.
include make.filelist

# The targets
all: library

$(LIBRARY): $(OBJ_FILES)
	$(AR) $(ARFLAGS) $@ $(OBJ_FILES)
	$(RANLIB) $@
        
library: $(LIBRARY)

clean:
	cd test && $(MAKE) $@
	-rm *.o *.mod *.a >/dev/null 2>&1

distclean:
	cd test && $(MAKE) $@
	-rm Makefile >/dev/null 2>&1

check: library
	cd test && $(MAKE) $@

# ...Gnu-style installation
install:
	$(INSTALL) -d $(DESTDIR)$(installdir)/include
	$(INSTALL_DATA) *.mod $(DESTDIR)$(installdir)/include
	$(INSTALL) -d $(DESTDIR)$(installdir)/lib
	$(INSTALL_DATA) $(LIBRARY) $(DESTDIR)$(installdir)/lib
	$(INSTALL_DATA) ../config.log $(DESTDIR)$(installdir)

# ...NCO-style installation
nco_install: FORCE
	$(INSTALL) -d $(DESTDIR)$(installdir)
	$(INSTALL_DATA) $(LIBRARY) $(DESTDIR)$(installdir)/lib$(distdir).a
	$(INSTALL) -d $(DESTDIR)$(installdir)/incmod/$(distdir)
	$(INSTALL_DATA) *.mod $(DESTDIR)$(installdir)/incmod/$(distdir)
	$(INSTALL_DATA) ../config.log $(DESTDIR)$(installdir)/config.log.$(distdir)

FORCE:
	@if [ -d $(DESTDIR)$(installdir) ]; then \
          echo; \
	  echo "*** NCO-style installation does not install into existing directories! ***"; \
	  echo "*** $(DESTDIR)$(installdir) already exists! ***"; \
          echo; \
	  exit 1; \
	fi
        
# ...Universal uninstallation
uninstall:
	-rm -fr $(DESTDIR)$(installdir) >/dev/null 2>&1

# ...Reconfig targets
Makefile: Makefile.in ../config.status
	cd .. && ./config.status libsrc/$@

../config.status: ../configure
	cd .. && ./config.status --recheck

# Specify targets that do not generate filesystem objects
.PHONY: all clean distclean check install uninstall

# File dependency and compilation rule include files
include make.dependencies
include make.rules
