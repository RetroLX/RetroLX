################################################################################
#
# LIBFREEAPTX
#
################################################################################

LIBFREEAPTX_VERSION = c176b7de9c2017d0fc1877659cea3bb6c330aafa
LIBFREEAPTX_SITE =  $(call github,iamthehorker,libfreeaptx,$(LIBFREEAPTX_VERSION))
LIBFREEAPTX_INSTALL_STAGING = YES
LIBFREEAPTX_DEPENDENCIES = host-pkgconf

define LIBFREEAPTX_BUILD_CMDS
	cd $(@D) && CC=$(TARGET_CC) LD=$(TARGET_LD) make
endef

define LIBFREEAPTX_INSTALL_STAGING_CMDS
	cd $(@D) && DESTDIR=$(STAGING_DIR) make install
endef

define LIBFREEAPTX_INSTALL_TARGET_CMDS
	cd $(@D) && DESTDIR=$(TARGET_DIR) make install
endef

$(eval $(generic-package))
