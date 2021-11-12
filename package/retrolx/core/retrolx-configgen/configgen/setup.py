#!/usr/bin/env python

from distutils.core import setup
setup(name='batocera-configgen',
      version='1.0',
      py_modules=['configgen'],
      packages=[
        'configgen',
        'configgen.generators',
        'configgen.generators.libretro',
        'configgen.generators.external',
        'configgen.generators.flatpak',
        'configgen.settings',
        'configgen.utils',
        ],
      )

#        package_data={
#          'configgen.generators.xash3d_fwgs': ['gamepad.cfg'],
#        },
