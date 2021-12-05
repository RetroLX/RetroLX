#!/usr/bin/env python
import Command
import retrolxFiles
from generators.Generator import Generator
import shutil
import os.path
import configparser
# TODO: python3 - delete me!
import codecs
import controllersConfig
from shutil import copyfile
from . import xemuConfig

def getGeneratorClass():
    return 'XemuGenerator'


class XemuGenerator(Generator):

    # Main entry of the module
    # Configure fba and return a command
    def generate(self, system, rom, playersControllers, gameResolution):
        xemuConfig.writeIniFile(system, rom, playersControllers)

        # copy the hdd if it doesn't exist
        if not os.path.exists("/userdata/saves/xbox/xbox_hdd.qcow2"):
            if not os.path.exists("/userdata/saves/xbox"):
                os.makedirs("/userdata/saves/xbox")
            copyfile("/usr/share/xemu/data/xbox_hdd.qcow2", "/userdata/saves/xbox/xbox_hdd.qcow2")

        # the command to run
        commandArray = [retrolxFiles.batoceraBins[system.config['emulator']]]
        commandArray.extend(["-config_path", retrolxFiles.xemuConfig])

        env = {}
        env["XDG_CONFIG_HOME"] = retrolxFiles.CONF
        env["SDL_GAMECONTROLLERCONFIG"] = controllersConfig.generateSdlGameControllerConfig(playersControllers)

        return Command.Command(array=commandArray, env=env)
