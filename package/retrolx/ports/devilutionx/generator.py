#!/usr/bin/env python

import Command
import os
import os.path
from generators.Generator import Generator
import controllersConfig

def getGeneratorClass():
    return 'DevilutionXGenerator'

class DevilutionXGenerator(Generator):

    def executionDirectory(self, config, rom):
        return os.path.dirname(os.path.abspath(__file__))

    def generate(self, system, rom, playersControllers, gameResolution):
        commandArray = ['./devilutionx', '--data-dir', '/userdata/roms/devilutionx',
                        '--config-dir', '/userdata/system/config/devilutionx',
                        '--save-dir', '/userdata/saves/devilutionx']
        if rom.endswith('hellfire.mpq'):
            commandArray.append('--hellfire')
        elif rom.endswith('spawn.mpq'):
            commandArray.append('--spawn')
        else:
            commandArray.append('--diablo')

        if system.isOptSet('showFPS') and system.getOptBoolean('showFPS') == True:
            commandArray.append('-f')
        return Command.Command(
            array=commandArray,
            env={
                'SDL_GAMECONTROLLERCONFIG': controllersConfig.generateSdlGameControllerConfig(playersControllers)
            })
