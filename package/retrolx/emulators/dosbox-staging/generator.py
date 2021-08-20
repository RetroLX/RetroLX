#!/usr/bin/env python
import Command
import batoceraFiles
from generators.Generator import Generator
import os.path
import glob
from pathlib import Path

def getGeneratorClass():
    return 'DosBoxStagingGenerator'

arch = Path('/usr/share/retrolx/retrolx.arch').read_text()
retrolxPackages = '/userdata/packages/' + arch
emulatorPath = retrolxPackages + '/dosbox-staging/bin/dosbox'
dosboxStagingCustom = batoceraFiles.CONF + '/dosbox'
dosboxStagingConfig = dosboxStagingCustom + '/dosbox.conf'

class DosBoxStagingGenerator(Generator):

    def getResolutionMode(self, config):
        return 'default'
    
    # Main entry of the module
    # Return command
    def generate(self, system, rom, playersControllers, gameResolution):
        # Find rom path
        gameDir = rom
        batFile = gameDir + "/dosbox.bat"
        gameConfFile = gameDir + "/dosbox.cfg"
           
        commandArray = [emulatorPath,
			"-fullscreen",
			"-userconf",
			"-exit",
			"""{}""".format(batFile),
			"-c", """set ROOT={}""".format(gameDir)]
        if os.path.isfile(gameConfFile):
            commandArray.append("-conf")
            commandArray.append("""{}""".format(gameConfFile))
        else:
            commandArray.append("-conf")
            commandArray.append("""{}""".format(dosboxStagingConfig))

        return Command.Command(array=commandArray)
