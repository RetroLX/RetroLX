#!/usr/bin/env python
import Command
import retrolxFiles
from generators.Generator import Generator
import os.path
import glob


def getGeneratorClass():
    return 'ScummVMGenerator'


class ScummVMGenerator(Generator):

    def getResolutionMode(self, config):
        return 'default'
    
    # Main entry of the module
    # Configure mupen and return a command
    def generate(self, system, rom, playersControllers, gameResolution):
        # Find rom path
        if os.path.isdir(rom):
          # rom is a directory: must contains a <game name>.scummvm file
          romPath = rom
          romFile = glob.glob(romPath + "/*.scummvm")[0]
          romName = os.path.splitext(os.path.basename(romFile))[0]
        else:
          # rom is a file: split in directory and file name
          romPath = os.path.dirname(rom)
          romName = os.path.splitext(os.path.basename(rom))[0]
        # Get rom name without extension
        commandArray = [retrolxFiles.batoceraBins[system.config['emulator']],
                        "-f",
                        "--joystick=0", 
                        "--screenshotspath="+retrolxFiles.screenshotsDir, 
                        "--extrapath=/usr/share/scummvm",
                        "--savepath="+retrolxFiles.scummvmSaves,
                        "--path=""{}""".format(romPath)]
        commandArray.append("""{}""".format(romName))

        return Command.Command(array=commandArray)
