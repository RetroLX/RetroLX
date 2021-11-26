#!/usr/bin/env python
import Command
import retrolxFiles
from generators.Generator import Generator
import os.path
import glob
from . import viceConfig
from . import viceControllers

def getGeneratorClass():
    return 'ViceGenerator'

    
class ViceGenerator(Generator):

    def getResolutionMode(self, config):
        return 'default'
    
    # Main entry of the module
    # Return command
    def generate(self, system, rom, playersControllers, gameResolution):

        if not os.path.exists(os.path.dirname(retrolxFiles.viceConfig)):
            os.makedirs(os.path.dirname(retrolxFiles.viceConfig))

        # configuration file
        viceConfig.setViceConfig(retrolxFiles.viceConfig, system)

        # controller configuration
        viceControllers.generateControllerConfig(retrolxFiles.viceConfig, playersControllers)

        commandArray = [retrolxFiles.batoceraBins[system.config['emulator']] + system.config['core'], "-autostart", rom]

        return Command.Command(array=commandArray, env={"XDG_CONFIG_HOME":retrolxFiles.CONF})
