#!/usr/bin/env python

import Command
import os
import re
import importlib.util
import sys
import tokenize
import batoceraFiles
from generators.Generator import Generator
from settings.unixSettings import UnixSettings
from utils.logger import eslog

class ExternalGenerator(Generator):

    def importExternalGenerator(package, emulator)
        externalGeneratorFilePath = retrolxPackages + '/' + package + '/' + emulator + '.py'
        externalGeneratorModuleName = emulator + 'Generator'
        if not os.path.exists(generatorFile):
            eslog.log('Cannot find external generator for package ' + package + ' and emulator ' + emulator)
            return Command.Command(array=commandArray)

        eslog.log('Loading ' + externalGeneratorFilePath + ' as module ' + externalGeneratorModuleName)
        spec = importlib.util.spec_from_file_location(module_name, file_path)
        module = importlib.util.module_from_spec(spec)
        sys.modules[module_name] = module
        spec.loader.exec_module(module)
        return module;

    # Main entry of the module
    def generate(self, system, rom, playersControllers, gameResolution):
        # Try to load external generator module
        module = importExternalGenerator(system.config['emulator'])
        # Call it as a regular configgen module
        return module.generate(self, system, rom, playersControllers, gameResolution)

