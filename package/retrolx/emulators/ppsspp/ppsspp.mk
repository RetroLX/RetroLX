################################################################################
#
# PPSSPP
#
################################################################################
# Version: March 2, 2021
PPSSPP_VERSION = v1.11.3
PPSSPP_SITE = https://github.com/hrydgard/ppsspp.git
PPSSPP_SITE_METHOD=git
PPSSPP_GIT_SUBMODULES=YES
PPSSPP_LICENSE = GPLv2
PPSSPP_DEPENDENCIES = sdl2 libzip

PPSSPP_PKG_DIR = $(TARGET_DIR)/opt/retrolx/ppsspp
PPSSPP_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/ppsspp

PPSSPP_CONF_OPTS = \
	-DUSE_FFMPEG=ON -DUSE_SYSTEM_FFMPEG=OFF -DUSING_FBDEV=ON -DUSE_WAYLAND_WSI=OFF \
	-DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME=Linux -DUSE_DISCORD=OFF \
	-DBUILD_SHARED_LIBS=OFF -DANDROID=OFF -DWIN32=OFF -DAPPLE=OFF \
	-DUNITTEST=OFF -DSIMULATOR=OFF

PPSSPP_TARGET_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_PACKAGE_QT5),y)
PPSSPP_CONF_OPTS += -DUSING_QT_UI=ON
PPSSPP_TARGET_BINARY = PPSSPPQt
else
PPSSPP_CONF_OPTS += -DUSING_QT_UI=OFF
PPSSPP_TARGET_BINARY = PPSSPPSDL
endif

# make sure to select glvnd and depends on glew / glu because of X11 desktop GL
ifeq ($(BR2_PACKAGE_RETROLX_IS_X86_ARCH),y)
	PPSSPP_CONF_OPTS += -DOpenGL_GL_PREFERENCE=GLVND
	PPSSPP_DEPENDENCIES += libglew libglu
endif

# enable vulkan if we are building with it
ifeq ($(BR2_PACKAGE_VULKAN_HEADERS)$(BR2_PACKAGE_VULKAN_LOADER),yy)
	PPSSPP_CONF_OPTS += -DVULKAN=ON
else
	PPSSPP_CONF_OPTS += -DVULKAN=OFF
endif

# enable x11/vulkan interface only if xorg
ifeq ($(BR2_PACKAGE_XORG7),y)
	PPSSPP_CONF_OPTS += -DUSING_X11_VULKAN=ON
else
	PPSSPP_CONF_OPTS += -DUSING_X11_VULKAN=OFF
	PPSSPP_TARGET_CFLAGS += -DEGL_NO_X11=1 -DMESA_EGL_NO_X11_HEADERS=1
endif

# x86
ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
	PPSSPP_CONF_OPTS += -DX86=ON
endif

# x86_64
ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
	PPSSPP_CONF_OPTS += -DX86_64=ON
endif

# rpi4 vulkan support
ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
	PPSSPP_CONF_OPTS += -DARM_NO_VULKAN=OFF
else
	PPSSPP_CONF_OPTS += -DARM_NO_VULKAN=ON
endif

# odroid c2 / S905 and variants
ifeq ($(BR2_aarch64),y)
PPSSPP_CONF_OPTS += \
	-DARM64=ON \
	-DUSING_GLES2=ON \
	-DUSING_EGL=ON
endif

# odroid / rpi / rockpro64
ifeq ($(BR2_arm),y)
PPSSPP_CONF_OPTS += \
	-DARMV7=ON \
	-DARM=ON \
	-DUSING_GLES2=ON
endif

# rockchip
ifeq ($(BR2_PACKAGE_RETROLX_ROCKCHIP_ANY),y)
ifeq ($(BR2_arm),y)
PPSSPP_CONF_OPTS += -DUSING_EGL=OFF
endif

# In order to support the custom resolution patch, permissive compile is needed
PPSSPP_TARGET_CFLAGS += -fpermissive
else
ifeq ($(BR2_arm),y)
PPSSPP_CONF_OPTS += -DUSING_EGL=ON
endif
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
PPSSPP_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-lmali -DCMAKE_SHARED_LINKER_FLAGS=-lmali
endif

# rpi1 / rpi2 /rp3
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	PPSSPP_DEPENDENCIES += rpi-userland
	PPSSPP_CONF_OPTS += -DPPSSPP_PLATFORM_RPI=1
endif

PPSSPP_CONF_OPTS += -DCMAKE_C_FLAGS="$(PPSSPP_TARGET_CFLAGS)" -DCMAKE_CXX_FLAGS="$(PPSSPP_TARGET_CFLAGS)"

define PPSSPP_UPDATE_INCLUDES
	sed -i 's/unknown/$(PPSSPP_VERSION)/g' $(@D)/git-version.cmake
	sed -i "s+/opt/vc+$(STAGING_DIR)/usr+g" $(@D)/CMakeLists.txt
endef

PPSSPP_PRE_CONFIGURE_HOOKS += PPSSPP_UPDATE_INCLUDES

define PPSSPP_INSTALL_TARGET_CMDS
	echo "PPSSPP built as package, no target install"
endef

define PPSSPP_MAKEPKG
	# Create directories
	mkdir -p $(PPSSPP_PKG_DIR)$(PPSSPP_PKG_INSTALL_DIR)/assets

	# Copy package files
	$(INSTALL) -D -m 0755 $(@D)/$(PPSSPP_TARGET_BINARY) $(PPSSPP_PKG_DIR)$(PPSSPP_PKG_INSTALL_DIR)/PPSSPP
	cp -R $(@D)/assets $(PPSSPP_PKG_DIR)$(PPSSPP_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(PPSSPP_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/ppsspp/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

PPSSPP_POST_INSTALL_TARGET_HOOKS = PPSSPP_MAKEPKG

$(eval $(cmake-package))
