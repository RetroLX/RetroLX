#!/usr/bin/env python

import Command
from generators.Generator import Generator
import controllersConfig


class CdogsGenerator(Generator):

    def generate(self, system, rom, playersControllers, gameResolution):
        commandArray = ["cdogs"]

        return Command.Command(
            array=commandArray,
            env={
                'SDL_GAMECONTROLLERCONFIG': controllersConfig.generateSdlGameControllerConfig(playersControllers)
            })
