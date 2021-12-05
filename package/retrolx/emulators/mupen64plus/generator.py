#!/usr/bin/env python
import Command
import retrolxFiles
from generators.Generator import Generator
import configparser
import os
from . import mupenConfig
from . import mupenControllers

def getGeneratorClass():
    return 'MupenGenerator'


class MupenGenerator(Generator):

    def generate(self, system, rom, playersControllers, gameResolution):

        # Read the configuration file
        iniConfig = configparser.ConfigParser(interpolation=None)
        # To prevent ConfigParser from converting to lower case
        iniConfig.optionxform = str
        if os.path.exists(retrolxFiles.mupenCustom):
            iniConfig.read(retrolxFiles.mupenCustom)

        mupenConfig.setMupenConfig(iniConfig, system, playersControllers, gameResolution)
        mupenControllers.setControllersConfig(iniConfig, playersControllers, system.config)

        # Save the ini file
        if not os.path.exists(os.path.dirname(retrolxFiles.mupenCustom)):
            os.makedirs(os.path.dirname(retrolxFiles.mupenCustom))
        with open(retrolxFiles.mupenCustom, 'w') as configfile:
            iniConfig.write(configfile)

        # Command
        commandArray = [retrolxFiles.batoceraBins[system.config['emulator']], "--corelib", "/usr/lib/libmupen64plus.so.2.0.0", "--gfx", "/usr/lib/mupen64plus/mupen64plus-video-{}.so".format(system.config['core']), "--configdir", retrolxFiles.mupenConf, "--datadir", retrolxFiles.mupenConf]
        commandArray.append(rom)

        return Command.Command(array=commandArray)
