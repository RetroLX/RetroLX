#!/usr/bin/env python
import Command
import batoceraFiles
from generators.Generator import Generator
import os.path
import glob
from pathlib import Path

def getGeneratorClass():
    return 'DosBoxGenerator'

arch = Path('/usr/share/retrolx/retrolx.arch').read_text()
retrolxPackages = '/userdata/packages/' + arch
emulatorPath = retrolxPackages + '/dosbox/bin/dosbox'
dosboxCustom = batoceraFiles.CONF + '/dosbox'
dosboxConfig = dosboxStagingCustom + '/dosbox.conf'

class DosBoxGenerator(Generator):

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
            commandArray.append("""{}""".format(dosboxConfig))

        return Command.Command(array=commandArray)
