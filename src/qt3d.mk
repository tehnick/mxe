# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt3d
$(PKG)_WEBSITE  := http://qt-project.org/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := b961789daecebed030ad36568301d1fe6c1ad97e9a2726fad5bd96ad603f439d
$(PKG)_SUBDIR    = $(subst qtbase,qt3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qt3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qt3d,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)' || $(MAKE) -C '$(1)' -j  1
    $(MAKE) -C '$(1)' -j 1 install
endef
