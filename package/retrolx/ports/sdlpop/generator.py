#!/usr/bin/env python

from generators.Generator import Generator
import os
import os.path
import Command
import controllersConfig

def getGeneratorClass():
    return 'SdlPopGenerator'

class SdlPopGenerator(Generator):

    def executionDirectory(self, config, rom):
        return os.path.dirname(os.path.abspath(__file__))

    def generate(self, system, rom, playersControllers, gameResolution):
        commandArray = ["./SDLPoP"]

        # pad number
        nplayer = 1
        for playercontroller, pad in sorted(playersControllers.items()):
            if nplayer == 1:
                commandArray.append("joynum={}".format(pad.index))
            nplayer += 1

        return Command.Command(array=commandArray,env={
            "SDL_GAMECONTROLLERCONFIG": controllersConfig.generateSdlGameControllerConfig(playersControllers)
        })
