################################################################################
#
# PLAY
#
################################################################################

PLAY_VERSION = 0.47
PLAY_SITE = https://github.com/jpd002/Play-.git
PLAY_LICENSE = BSD
PLAY_DEPENDENCIES = qt5base qt5x11extras xserver_xorg-server libglew

PLAY_SITE_METHOD = git
PLAY_GIT_SUBMODULES = YES

PLAY_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
PLAY_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
PLAY_CONF_OPTS += -DBUILD_TESTS=OFF

$(eval $(cmake-package))
