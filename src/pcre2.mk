# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pcre2
$(PKG)_WEBSITE  := http://www.pcre.org/
$(PKG)_DESCR    := PCRE2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 10.23
$(PKG)_CHECKSUM := dfc79b918771f02d33968bd34a749ad7487fa1014aeb787fad29dd392b78c56e
$(PKG)_SUBDIR   := pcre2-$($(PKG)_VERSION)
$(PKG)_FILE     := pcre2-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.pcre.org/pub/pcre/$($(PKG)_FILE)
$(PKG)_URL_2    := https://$(SOURCEFORGE_MIRROR)/project/pcre/pcre2/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.pcre.org/pub/pcre/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pcre2-16 \
        --enable-utf \
        --enable-unicode-properties \
        --enable-cpp \
        --disable-pcre2grep-libz \
        --disable-pcre2grep-libbz2 \
        --disable-pcre2test-libreadline
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGRAMS) dist_html_DATA= dist_doc_DATA=
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man1/pcre*.1
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/pcre*.3
    ln -sf '$(PREFIX)/$(TARGET)/bin/pcre2-config' '$(PREFIX)/bin/$(TARGET)-pcre2-config'
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/src/pcre2.h.in'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/src/pcre2posix.h'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/src/pcre2.h.generic'
    $($(PKG)_BUILD_SHARED)
endef
