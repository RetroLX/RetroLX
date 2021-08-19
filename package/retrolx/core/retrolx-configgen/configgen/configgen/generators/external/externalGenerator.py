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

def importExternalGenerator(package):
    externalGeneratorFilePath = batoceraFiles.retrolxPackages + '/' + package + '/generator.py'
    externalGeneratorModuleName = package
    if not os.path.exists(externalGeneratorFilePath):
        eslog.log('Cannot find external generator for package: ' + package)
        return None

    eslog.log('Importing ' + externalGeneratorFilePath + ' as module ' + externalGeneratorModuleName)
    spec = importlib.util.spec_from_file_location(externalGeneratorModuleName, externalGeneratorFilePath)
    module = importlib.util.module_from_spec(spec)
    sys.modules[externalGeneratorModuleName] = module
    spec.loader.exec_module(module)
    generatorName = getattr(module,'getGeneratorClass')()
    generator = getattr(module,generatorName)();
    return generator


class ExternalGenerator(Generator):

    def generate(self, system, rom, playersControllers, gameResolution):
        # Try to load external generator module
        generator = importExternalGenerator(config['emulator'])
        # Call it as a regular configgen module
        return generator.generate(system, rom, playersControllers, gameResolution)

    def getResolutionMode(self, config):
        # Try to load external generator module
        generator = importExternalGenerator(config['emulator'])
        # Call it as a regular configgen module
        return generator.getResolutionMode(config)

    def getMouseMode(self, config):
        # Try to load external generator module
        generator = importExternalGenerator(config['emulator'])
        # Call it as a regular configgen module
        return generator.getMouseMose(config)

    def executionDirectory(self, config, rom):
        # Try to load external generator module
        generator = importExternalGenerator(config['emulator'])
        # Call it as a regular configgen module
        return generator.executionDirectory(config, rom)
