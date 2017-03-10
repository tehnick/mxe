# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libotr
$(PKG)_WEBSITE  := https://otr.cypherpunks.ca/
$(PKG)_DESCR    := Off-the-Record Messaging
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.1
$(PKG)_CHECKSUM := 8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://otr.cypherpunks.ca/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://otr.cypherpunks.ca/' | \
    $(SED) -n 's,.*<a href="libotr-\([0-9][^>]*\)\.tar\.gz">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
