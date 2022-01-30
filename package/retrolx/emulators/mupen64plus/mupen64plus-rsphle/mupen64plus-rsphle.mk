################################################################################
#
# mupen64plus rsp-hle
#
################################################################################
# Version.: Commits on Jan 16, 2022
MUPEN64PLUS_RSPHLE_VERSION = 4bac3aeb98aff2d89095c59ec105aad721a16167
MUPEN64PLUS_RSPHLE_SITE = $(call github,mupen64plus,mupen64plus-rsp-hle,$(MUPEN64PLUS_RSPHLE_VERSION))
MUPEN64PLUS_RSPHLE_LICENSE = GPLv2
MUPEN64PLUS_RSPHLE_DEPENDENCIES = sdl2 alsa-lib mupen64plus-core
MUPEN64PLUS_RSPHLE_INSTALL_STAGING = YES

define MUPEN64PLUS_RSPHLE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
		PREFIX="$(STAGING_DIR)/usr" \
		PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
		HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
		APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
		GL_CFLAGS="$(MUPEN64PLUS_GL_CFLAGS)" \
		GL_LDLIBS="$(MUPEN64PLUS_GL_LDLIBS)" \
		-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)"
endef

define MUPEN64PLUS_RSPHLE_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
		PREFIX="$(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)" \
		PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
		HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
		APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
		GL_CFLAGS="$(MUPEN64PLUS_GL_CFLAGS)" \
		GL_LDLIBS="$(MUPEN64PLUS_GL_LDLIBS)" \
		INSTALL="/usr/bin/install" \
		INSTALL_STRIP_FLAG="" \
		-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)" install
endef

$(eval $(generic-package))
