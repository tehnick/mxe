# This file is part of MXE.
# See index.html for further information.

PKG             := ffmpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0
$(PKG)_CHECKSUM := f19ff77a2f7f736a41dd1499eef4784bf3cb7461f07c13a268164823590113c0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://launchpad.net/ffmpeg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 x264 yasm zlib

# DO NOT ADD fdk-aac OR openssl SUPPORT.
# Although they are free softwares, their licenses are not compatible with
# the GPL, and we'd like to enable GPL in our default ffmpeg build.
# See index.html#potential-legal-issues

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ffmpeg.org/releases/' | \
    $(SED) -n 's,.*ffmpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha\|beta\|rc\|git' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
    CPPFLAGS="$(CPPFLAGS)" \
    CFLAGS="$(CFLAGS)" \
    CXXFLAGS="$(CXXFLAGS)" \
    LDFLAGS="$(LDFLAGS)" \
    ./configure \
        --cross-prefix='$(TARGET)'- \
        --enable-cross-compile \
        --arch=$(firstword $(subst -, ,$(TARGET))) \
        --target-os=mingw32 \
        --prefix='$(PREFIX)/$(TARGET)' \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared ) \
        --yasmexe='$(TARGET)-yasm' \
        --disable-debug \
        --enable-memalign-hack \
        --disable-pthreads \
        --enable-w32threads \
        --disable-doc \
        --enable-avresample \
        --enable-gpl \
        --enable-version3 \
        --extra-libs='-mconsole' \
        --enable-avisynth \
        --disable-gnutls \
        --disable-libass \
        --disable-libbluray \
        --disable-libbs2b \
        --disable-libcaca \
        --disable-libmp3lame \
        --disable-libopencore-amrnb \
        --disable-libopencore-amrwb \
        --disable-libopus \
        --disable-libspeex \
        --disable-libtheora \
        --disable-libvidstab \
        --disable-libvo-amrwbenc \
        --disable-libvorbis \
        --disable-libvpx \
        --enable-libx264 \
        --disable-libxvid
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
