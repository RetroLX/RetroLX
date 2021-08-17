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

def importExternalGenerator(package, emulator):
    externalGeneratorFilePath = batoceraFiles.retrolxPackages + '/' + package + '/' + emulator + '.py'
    eslog.log(externalGeneratorFilePath)
    externalGeneratorModuleName = emulator + 'Generator'
    eslog.log(externalGeneratorModuleName)
    if not os.path.exists(externalGeneratorFilePath):
        eslog.log('Cannot find external generator for package ' + package + ' emulator ' + emulator)
        return None

    eslog.log('Loading ' + externalGeneratorFilePath + ' as module ' + externalGeneratorModuleName)
    spec = importlib.util.spec_from_file_location(module_name, file_path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)
    return module


class ExternalGenerator(Generator):

    # Main entry of the module
    def generate(self, system, rom, playersControllers, gameResolution):
        # Try to load external generator module
        module = importExternalGenerator(system.config['emulator'], system.config['emulator'])
        # Call it as a regular configgen module
        return module.generate(self, system, rom, playersControllers, gameResolution)


    def getResolutionMode(self, config):
        # Try to load external generator module
        module = importExternalGenerator(config['emulator'], config['emulator'])
        # Call it as a regular configgen module
        return module.getResolutionMode(self, config)

    def getMouseMode(self, config):
        # Try to load external generator module
        module = importExternalGenerator(config['emulator'], config['emulator'])
        # Call it as a regular configgen module
        return module.getMouseMose(self, config)

    def executionDirectory(self, config, rom):
        # Try to load external generator module
        module = importExternalGenerator(config['emulator'], config['emulator'])
        # Call it as a regular configgen module
        return module.executionDirectory(module)
