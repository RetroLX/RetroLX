#!/usr/bin/env python

from generators.Generator import Generator
import retrolxFiles
import Command
import shutil
import os
from utils.logger import eslog
from os import path
from os import environ
import configparser
import yaml
import json
from . import rpcs3Controllers

def getGeneratorClass():
    return 'Rpcs3Generator'


class Rpcs3Generator(Generator):

    def generate(self, system, rom, playersControllers, gameResolution):

        rpcs3Controllers.generateControllerConfig(system, playersControllers, rom)

        # Taking care of the CurrentSettings.ini file
        if not os.path.exists(os.path.dirname(retrolxFiles.rpcs3CurrentConfig)):
            os.makedirs(os.path.dirname(retrolxFiles.rpcs3CurrentConfig))
            
        # Generates CurrentSettings.ini with values to disable prompts on first run
        
        rpcsCurrentSettings = configparser.ConfigParser(interpolation=None)
        # To prevent ConfigParser from converting to lower case
        rpcsCurrentSettings.optionxform = str
        if os.path.exists(retrolxFiles.rpcs3CurrentConfig):
            rpcsCurrentSettings.read(retrolxFiles.rpcs3CurrentConfig)
        
        # Sets Gui Settings to close completely and disables some popups
        if not rpcsCurrentSettings.has_section("main_window"):
            rpcsCurrentSettings.add_section("main_window")  
        
        rpcsCurrentSettings.set("main_window", "confirmationBoxExitGame", "false")
        rpcsCurrentSettings.set("main_window", "infoBoxEnabledInstallPUP","false")
        rpcsCurrentSettings.set("main_window", "infoBoxEnabledWelcome","false")
                
        with open(retrolxFiles.rpcs3CurrentConfig, 'w') as configfile:
            rpcsCurrentSettings.write(configfile)
        
        if not os.path.exists(os.path.dirname(retrolxFiles.rpcs3config)):
            os.makedirs(os.path.dirname(retrolxFiles.rpcs3config))    

        # Generate a default config if it doesn't exist otherwise just open the existing
        rpcs3ymlconfig = {}
        if os.path.isfile(retrolxFiles.rpcs3config):
            with open(retrolxFiles.rpcs3config, 'r') as stream:
                rpcs3ymlconfig = yaml.load(stream)

        if rpcs3ymlconfig is None: # in case the file is empty
            rpcs3ymlconfig = {}

        # Add Node Core
        if "Core" not in rpcs3ymlconfig:
            rpcs3ymlconfig["Core"] = {}
            
        # Add Node Video
        if "Video" not in rpcs3ymlconfig:
            rpcs3ymlconfig["Video"] = {}
            
        # Add Node Audio
        if "Audio" not in rpcs3ymlconfig:
            rpcs3ymlconfig["Audio"] = {}   

        # Add Node Miscellaneous
        if "Miscellaneous" not in rpcs3ymlconfig:
            rpcs3ymlconfig["Miscellaneous"] = {}  

        # Set the Default Core Values we need
        rpcs3ymlconfig["Core"]['SPU Decoder'] = 'Interpreter (fast)'
        rpcs3ymlconfig["Core"]['Lower SPU thread priority'] = False
        rpcs3ymlconfig["Core"]['SPU Cache'] = False
        rpcs3ymlconfig["Core"]['PPU LLVM Accurate Vector NaN values'] = True     
 
        rpcs3ymlconfig["Video"]['Frame limit'] = 60

        # gfx backend
        if system.isOptSet("gfxbackend"):
            rpcs3ymlconfig["Video"]['Renderer'] = system.config["gfxbackend"]
        else:
            rpcs3ymlconfig["Video"]['Renderer'] = 'OpenGL' # Vulkan

        rpcs3ymlconfig["Audio"]['Renderer'] = 'OpenAL' # ALSA does not support buffering so we have sound cuts ex: Rayman Origin
        rpcs3ymlconfig["Audio"]['Audio Channels'] = 'Downmix to Stereo'
        
        rpcs3ymlconfig["Miscellaneous"]['Exit RPCS3 when process finishes'] = True
        rpcs3ymlconfig["Miscellaneous"]['Start games in fullscreen mode'] = True       

        with open(retrolxFiles.rpcs3config, 'w') as file:
            documents = yaml.safe_dump(rpcs3ymlconfig, file, default_flow_style=False)

        romBasename = path.basename(rom)
        romName = rom + '/PS3_GAME/USRDIR/EBOOT.BIN'
        commandArray = [retrolxFiles.batoceraBins[system.config['emulator']], romName]

        if system.isOptSet("gui") and system.getOptBoolean("gui") == False:
            commandArray.append("--no-gui")

        return Command.Command(array=commandArray, env={"XDG_CONFIG_HOME":retrolxFiles.CONF, "XDG_CACHE_HOME":retrolxFiles.SAVES, "QT_QPA_PLATFORM":retrolxFiles.qt_qpa_platform})
