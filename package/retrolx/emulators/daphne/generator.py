#!/usr/bin/env python

import Command
import retrolxFiles
from generators.Generator import Generator
import shutil
import os
from . import daphneControllers

def getGeneratorClass():
    return 'DaphneGenerator'

class DaphneGenerator(Generator):

    # Main entry of the module
    def generate(self, system, rom, playersControllers, gameResolution):
        if not os.path.exists(os.path.dirname(retrolxFiles.daphneConfig)):
            os.makedirs(os.path.dirname(retrolxFiles.daphneConfig))

        # controllers
        daphneControllers.generateControllerConfig(retrolxFiles.daphneConfig, playersControllers)

        # extension used .daphne and the file to start the game is in the folder .daphne with the extension .txt
        romName = os.path.splitext(os.path.basename(rom))[0]
        frameFile = rom + "/" + romName + ".txt"
        commandsFile = rom + "/" + romName + ".commands"
        
        if system.config["ratio"] == "16/9":
            commandArray = [retrolxFiles.batoceraBins[system.config['emulator']],
                            romName, "vldp", "-framefile", frameFile, "-useoverlaysb", "2", "-ignore_aspect_ratio",
                            "-x", str(gameResolution["width"]), "-y", str(gameResolution["height"]), "-fullscreen",
                            "-fastboot", "-datadir", retrolxFiles.daphneDatadir, "-homedir", retrolxFiles.daphneHomedir]
        else:
            commandArray = [retrolxFiles.batoceraBins[system.config['emulator']],
                            romName, "vldp", "-framefile", frameFile, "-useoverlaysb", "2", "-fullscreen",
                            "-fastboot", "-datadir", retrolxFiles.daphneDatadir, "-homedir", retrolxFiles.daphneHomedir]

        # The folder may have a file with the game name and .commands with extra arguments to run the game.
        if os.path.isfile(commandsFile):
            commandArray.extend(open(commandsFile,'r').read().split())
        
        return Command.Command(array=commandArray)
 
