################################################################################
#
# ECM
#
################################################################################

ECM_VERSION = v5.84.0
ECM_SITE =  $(call github,KDE,extra-cmake-modules,$(ECM_VERSION))
ECM_INSTALL_STAGING = YES

$(eval $(cmake-package))
