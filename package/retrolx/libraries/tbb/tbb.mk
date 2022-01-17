################################################################################
#
# TBB
#
################################################################################

TBB_VERSION = v2021.5.0
TBB_SITE =  $(call github,oneapi-src,oneTBB,$(TBB_VERSION))
TBB_INSTALL_STAGING = YES

TBB_CONF_OPTS = -DTBB_TEST=OFF -DTBB_STRICT=OFF -DTBBMALLOC_BUILD=OFF

ifeq ($(BR2_arm),y)
TBB_CONF_OPTS += -DCMAKE_C_FLAGS=-D__aarch32__ -DCMAKE_CXX_FLAGS=-D__aarch32__
endif

$(eval $(cmake-package))
