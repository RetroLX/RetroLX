################################################################################
#
# nvidia-driver
#
################################################################################

RETROLX_NVIDIA_DRIVER_VERSION = 510.68.02
RETROLX_NVIDIA_DRIVER_SUFFIX = $(if $(BR2_x86_64),_64)
RETROLX_NVIDIA_DRIVER_SITE = http://download.nvidia.com/XFree86/Linux-x86$(RETROLX_NVIDIA_DRIVER_SUFFIX)/$(RETROLX_NVIDIA_DRIVER_VERSION)
RETROLX_NVIDIA_DRIVER_SOURCE = NVIDIA-Linux-x86$(RETROLX_NVIDIA_DRIVER_SUFFIX)-$(RETROLX_NVIDIA_DRIVER_VERSION).run
RETROLX_NVIDIA_DRIVER_LICENSE = NVIDIA Software License
RETROLX_NVIDIA_DRIVER_LICENSE_FILES = LICENSE
RETROLX_NVIDIA_DRIVER_REDISTRIBUTE = NO
RETROLX_NVIDIA_DRIVER_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_RETROLX_NVIDIA_DRIVER_XORG),y)

# Since nvidia-driver are binary blobs, the below dependencies are not
# strictly speaking build dependencies of nvidia-driver. However, they
# are build dependencies of packages that depend on nvidia-driver, so
# they should be built prior to those packages, and the only simple
# way to do so is to make nvidia-driver depend on them.
#batocera enable nvidia-driver and mesa3d to coexist in the same fs
RETROLX_NVIDIA_DRIVER_DEPENDENCIES = mesa3d xlib_libX11 xlib_libXext libglvnd
# RETROLX_NVIDIA_DRIVER_PROVIDES = libgl libegl libgles

# batocera modified to suport the vendor-neutral "dispatching" API/ABI
#   https://github.com/aritger/linux-opengl-abi-proposal/blob/master/linux-opengl-abi-proposal.txt
#batocera generic GL libraries are provided by libglvnd
#batocera only vendor version are installed
RETROLX_NVIDIA_DRIVER_LIBS_GL = \
	libGLX_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION)

RETROLX_NVIDIA_DRIVER_LIBS_EGL = \
	libEGL_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION)

RETROLX_NVIDIA_DRIVER_LIBS_GLES = \
	libGLESv1_CM_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libGLESv2_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION)

#batocera libnvidia-egl-wayland soname bump
RETROLX_NVIDIA_DRIVER_LIBS_MISC = \
	libnvidia-eglcore.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-egl-gbm.so.1.1.0 \
	libnvidia-egl-wayland.so.1.1.9 \
	libnvidia-glcore.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-glsi.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-tls.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libvdpau_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-ml.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-glvkspirv.so.$(RETROLX_NVIDIA_DRIVER_VERSION)

RETROLX_NVIDIA_DRIVER_LIBS += \
	$(RETROLX_NVIDIA_DRIVER_LIBS_GL) \
	$(RETROLX_NVIDIA_DRIVER_LIBS_EGL) \
	$(RETROLX_NVIDIA_DRIVER_LIBS_GLES) \
	$(RETROLX_NVIDIA_DRIVER_LIBS_MISC)

# batocera 32bit libraries
RETROLX_NVIDIA_DRIVER_32 = \
	$(RETROLX_NVIDIA_DRIVER_LIBS_GL) \
	$(RETROLX_NVIDIA_DRIVER_LIBS_EGL) \
	$(RETROLX_NVIDIA_DRIVER_LIBS_GLES) \
	libnvidia-eglcore.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-glcore.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-glsi.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-tls.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libvdpau_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-ml.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-glvkspirv.so.$(RETROLX_NVIDIA_DRIVER_VERSION)

# Install the gl.pc file
define RETROLX_NVIDIA_DRIVER_INSTALL_GL_DEV
	$(INSTALL) -D -m 0644 $(@D)/libGL.la $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__GENERATED_BY__:Buildroot:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__LIBGL_PATH__:/usr/lib:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:-L[^[:space:]]\+::' $(STAGING_DIR)/usr/lib/libGL.la
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/nvidia-driver/gl.pc $(STAGING_DIR)/usr/lib/pkgconfig/gl.pc
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/nvidia-driver/egl.pc $(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
endef

# Those libraries are 'private' libraries requiring an agreement with
# NVidia to develop code for those libs. There seems to be no restriction
# on using those libraries (e.g. if the user has such an agreement, or
# wants to run a third-party program developped under such an agreement).
ifeq ($(BR2_PACKAGE_RETROLX_NVIDIA_DRIVER_PRIVATE_LIBS),y)
RETROLX_NVIDIA_DRIVER_LIBS += \
	libnvidia-ifr.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-fbc.so.$(RETROLX_NVIDIA_DRIVER_VERSION)
endif

# We refer to the destination path; the origin file has no directory component
# batocera libnvidia-wfb removed in 418.43
RETROLX_NVIDIA_DRIVER_X_MODS = \
	drivers/nvidia_drv.so
#	libnvidia-wfb.so.$(RETROLX_NVIDIA_DRIVER_VERSION)
endif # X drivers

ifeq ($(BR2_PACKAGE_RETROLX_NVIDIA_DRIVER_CUDA),y)
RETROLX_NVIDIA_DRIVER_LIBS += \
	libcuda.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-compiler.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvcuvid.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-fatbinaryloader.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-ptxjitcompiler.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	libnvidia-encode.so.$(RETROLX_NVIDIA_DRIVER_VERSION)
ifeq ($(BR2_PACKAGE_RETROLX_NVIDIA_DRIVER_CUDA_PROGS),y)
RETROLX_NVIDIA_DRIVER_PROGS = nvidia-cuda-mps-control nvidia-cuda-mps-server
endif
endif

ifeq ($(BR2_PACKAGE_RETROLX_NVIDIA_DRIVER_OPENCL),y)
RETROLX_NVIDIA_DRIVER_LIBS += \
	libOpenCL.so.1.0.0 \
	libnvidia-opencl.so.$(RETROLX_NVIDIA_DRIVER_VERSION)
RETROLX_NVIDIA_DRIVER_DEPENDENCIES += mesa3d-headers
RETROLX_NVIDIA_DRIVER_PROVIDES += libopencl
endif

# The downloaded archive is in fact an auto-extract script. So, it can run
# virtually everywhere, and it is fine enough to provide useful options.
# Except it can't extract into an existing (even empty) directory.
define RETROLX_NVIDIA_DRIVER_EXTRACT_CMDS
	$(SHELL) $(RETROLX_NVIDIA_DRIVER_DL_DIR)/$(RETROLX_NVIDIA_DRIVER_SOURCE) --extract-only --target \
		$(@D)/tmp-extract
	chmod u+w -R $(@D)
	mv $(@D)/tmp-extract/* $(@D)/tmp-extract/.manifest $(@D)
	rm -rf $(@D)/tmp-extract
endef

# Helper to install libraries
# $1: destination directory (target or staging)
#
# For all libraries, we install them and create a symlink using
# their SONAME, so we can link to them at runtime; we also create
# the no-version symlink, so we can link to them at build time.
define RETROLX_NVIDIA_DRIVER_INSTALL_LIBS
	$(foreach lib,$(RETROLX_NVIDIA_DRIVER_LIBS),\
		$(INSTALL) -D -m 0644 $(@D)/$(lib) $(1)/usr/lib/$(notdir $(lib))
		libsoname="$$( $(TARGET_READELF) -d "$(@D)/$(lib)" \
			|sed -r -e '/.*\(SONAME\).*\[(.*)\]$$/!d; s//\1/;' )"; \
		if [ -n "$${libsoname}" -a "$${libsoname}" != "$(notdir $(lib))" ]; then \
			ln -sf $(notdir $(lib)) \
				$(1)/usr/lib/$${libsoname}; \
		fi
		baseso=$(firstword $(subst .,$(space),$(notdir $(lib)))).so; \
		if [ -n "$${baseso}" -a "$${baseso}" != "$(notdir $(lib))" ]; then \
			ln -sf $(notdir $(lib)) $(1)/usr/lib/$${baseso}; \
		fi
	)
endef

# batocera install 32bit libraries
define RETROLX_NVIDIA_DRIVER_INSTALL_32
	$(foreach lib,$(RETROLX_NVIDIA_DRIVER_32),\
		$(INSTALL) -D -m 0644 $(@D)/32/$(lib) $(1)/lib32/$(notdir $(lib))
		libsoname="$$( $(TARGET_READELF) -d "$(@D)/$(lib)" \
			|sed -r -e '/.*\(SONAME\).*\[(.*)\]$$/!d; s//\1/;' )"; \
		if [ -n "$${libsoname}" -a "$${libsoname}" != "$(notdir $(lib))" ]; then \
			ln -sf $(notdir $(lib)) \
				$(1)/lib32/$${libsoname}; \
		fi
		baseso=$(firstword $(subst .,$(space),$(notdir $(lib)))).so; \
		if [ -n "$${baseso}" -a "$${baseso}" != "$(notdir $(lib))" ]; then \
			ln -sf $(notdir $(lib)) $(1)/lib32/$${baseso}; \
		fi
	)
endef

# batocera nvidia libs are runtime linked via libglvnd
# For staging, install libraries and development files
# define RETROLX_NVIDIA_DRIVER_INSTALL_STAGING_CMDS
# 	$(call RETROLX_NVIDIA_DRIVER_INSTALL_LIBS,$(STAGING_DIR))
# 	$(RETROLX_NVIDIA_DRIVER_INSTALL_GL_DEV)
# endef

# For target, install libraries and X.org modules
define RETROLX_NVIDIA_DRIVER_INSTALL_TARGET_CMDS
	$(call RETROLX_NVIDIA_DRIVER_INSTALL_LIBS,$(TARGET_DIR))
	$(call RETROLX_NVIDIA_DRIVER_INSTALL_32,$(TARGET_DIR))
	$(foreach m,$(RETROLX_NVIDIA_DRIVER_X_MODS), \
		$(INSTALL) -D -m 0644 $(@D)/$(notdir $(m)) \
			$(TARGET_DIR)/usr/lib/xorg/modules/$(m)
	)
	$(foreach p,$(RETROLX_NVIDIA_DRIVER_PROGS), \
		$(INSTALL) -D -m 0755 $(@D)/$(p) \
			$(TARGET_DIR)/usr/bin/$(p)
	)

# batocera install files needed by Vulkan
	$(INSTALL) -D -m 0644 $(@D)/nvidia_layers.json \
		$(TARGET_DIR)/usr/share/vulkan/implicit_layer.d/nvidia_layers.json

# batocera install files needed by libglvnd
	$(INSTALL) -D -m 0644 $(@D)/10_nvidia.json \
		$(TARGET_DIR)/usr/share/glvnd/egl_vendor.d/10_nvidia.json

	$(INSTALL) -D -m 0644 $(@D)/nvidia-drm-outputclass.conf \
		$(TARGET_DIR)/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf

	$(INSTALL) -D -m 0644 $(@D)/libglxserver_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	 	$(TARGET_DIR)/usr/lib/xorg/modules/extensions/libglxserver_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION)
	ln -sf libglxserver_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	 	$(TARGET_DIR)/usr/lib/xorg/modules/extensions/libglxserver_nvidia.so
	ln -sf libglxserver_nvidia.so.$(RETROLX_NVIDIA_DRIVER_VERSION) \
	 	$(TARGET_DIR)/usr/lib/xorg/modules/extensions/libglxserver_nvidia.so.1

endef

define RETROLX_NVIDIA_DRIVER_VULKANJSON_X86_64
	$(INSTALL) -D -m 0644 $(@D)/nvidia_icd.json $(TARGET_DIR)/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json
        sed -i -e s+'"library_path": "libGLX_nvidia'+'"library_path": "/usr/lib/libGLX_nvidia'+ $(TARGET_DIR)/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json
	$(INSTALL) -D -m 0644 $(@D)/nvidia_icd.json $(TARGET_DIR)/usr/share/vulkan/icd.d/nvidia_icd.i686.json
        sed -i -e s+'"library_path": "libGLX_nvidia'+'"library_path": "/lib32/libGLX_nvidia'+ $(TARGET_DIR)/usr/share/vulkan/icd.d/nvidia_icd.i686.json
endef

define RETROLX_NVIDIA_DRIVER_VULKANJSON_X86
	$(INSTALL) -D -m 0644 $(@D)/nvidia_icd.json $(TARGET_DIR)/usr/share/vulkan/icd.d/nvidia_icd.i686.json
endef

ifeq ($(BR2_x86_64),y)
	RETROLX_NVIDIA_DRIVER_POST_INSTALL_TARGET_HOOKS += RETROLX_NVIDIA_DRIVER_VULKANJSON_X86_64
endif
ifeq ($(BR2_x86_i686),y)
	RETROLX_NVIDIA_DRIVER_POST_INSTALL_TARGET_HOOKS += RETROLX_NVIDIA_DRIVER_VULKANJSON_X86
endif

$(eval $(generic-package))
