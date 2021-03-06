#!/usr/bin/env python
import Command
import retrolxFiles
from . import libretroConfig
from . import libretroRetroarchCustom
from . import libretroControllers
import shutil
from generators.Generator import Generator
import os.path
from settings.unixSettings import UnixSettings
from utils.logger import eslog
import os
import sys

# Helper for package system
# Find a core in the packages folder
def findCore(core):
    path = os.path.abspath(retrolxFiles.retrolxPackages)
    file = core + retrolxFiles.libretroExt
    for root, dirs, files in os.walk(path):
        for filename in files:
            if filename == file:
                file_path = os.path.join(root, filename)
                return file_path
    return ""



class LibretroGenerator(Generator):

    # Main entry of the module
    # Configure retroarch and return a command
    def generate(self, system, rom, playersControllers, gameResolution):
        # Settings batocera default config file if no user defined one
        if not 'configfile' in system.config:
            # Using batocera config file
            system.config['configfile'] = retrolxFiles.retroarchCustom
            # Create retroarchcustom.cfg if does not exists
            if not os.path.isfile(retrolxFiles.retroarchCustom):
                libretroRetroarchCustom.generateRetroarchCustom()
            #  Write controllers configuration files
            retroconfig = UnixSettings(retrolxFiles.retroarchCustom, separator=' ')
            libretroControllers.writeControllersConfig(retroconfig, system, playersControllers)
            # force pathes
            libretroRetroarchCustom.generateRetroarchCustomPathes(retroconfig)
            # Write configuration to retroarchcustom.cfg
            if 'bezel' not in system.config or system.config['bezel'] == '':
                bezel = None
            else:
                bezel = system.config['bezel']
            # some systems (ie gw) won't bezels
            if system.isOptSet('forceNoBezel') and system.getOptBoolean('forceNoBezel'):
                bezel = None

            libretroConfig.writeLibretroConfig(retroconfig, system, playersControllers, rom, bezel, gameResolution)
            retroconfig.write()

        # Retroarch core on the filesystem
        retroarchCore = findCore(system.config['core'])
        romName = os.path.basename(rom)


        # The command to run
        # For the NeoGeo CD (lr-fbneo) it is necessary to add the parameter: --subsystem neocd
        if system.name == 'neogeocd' and system.config['core'] == "fbneo":
            commandArray = [retrolxFiles.batoceraBins[system.config['emulator']], "-L", retroarchCore, "--subsystem", "neocd", "--config", system.config['configfile']]
        # PURE zip games uses the same commandarray of all cores. .pc and .rom  uses owns
        elif system.name == 'dos':
            romDOSName = os.path.splitext(romName)[0]
            romDOSName, romExtension = os.path.splitext(romName)
            if romExtension == '.dos' or romExtension == '.pc':
                if os.path.isfile(os.path.join(rom, romDOSName + ".bat")):
                    commandArray = [retrolxFiles.batoceraBins[system.config['emulator']], "-L", retroarchCore, "--config", system.config['configfile'], os.path.join(rom, romDOSName + ".bat")]
                else:
                    commandArray = [retrolxFiles.batoceraBins[system.config['emulator']], "-L", retroarchCore, "--config", system.config['configfile'], rom + "/dosbox.bat"]
            else:
                commandArray = [retrolxFiles.batoceraBins[system.config['emulator']], "-L", retroarchCore, "--config", system.config['configfile']]
        else:
            commandArray = [retrolxFiles.batoceraBins[system.config['emulator']], "-L", retroarchCore, "--config", system.config['configfile']]

        configToAppend = []


        # Custom configs - per core
        customCfg = "{}/{}.cfg".format(retrolxFiles.retroarchRoot, system.name)
        if os.path.isfile(customCfg):
            configToAppend.append(customCfg)

        # Custom configs - per game
        customGameCfg = "{}/{}/{}.cfg".format(retrolxFiles.retroarchRoot, system.name, romName)
        if os.path.isfile(customGameCfg):
            configToAppend.append(customGameCfg)

        # Overlay management
        overlayFile = "{}/{}/{}.cfg".format(retrolxFiles.OVERLAYS, system.name, romName)
        if os.path.isfile(overlayFile):
            configToAppend.append(overlayFile)

        # RetroArch 1.7.8 (Batocera 5.24) now requires the shaders to be passed as command line argument
        renderConfig = system.renderconfig
        if 'shader' in renderConfig and renderConfig['shader'] != None:
            if ( (system.isOptSet("gfxbackend") and system.config["gfxbackend"] == "vulkan")
                    or (system.config['core'] in libretroConfig.coreForceSlangShaders) ):
                shaderFilename = renderConfig['shader'] + ".slangp"
            else:
                shaderFilename = renderConfig['shader'] + ".glslp"
            eslog.log("searching shader {}".format(shaderFilename))
            if os.path.exists("/userdata/shaders/" + shaderFilename):
                video_shader_dir = "/userdata/shaders"
                eslog.log("shader {} found in /userdata/shaders".format(shaderFilename))
            else:
                video_shader_dir = retrolxFiles.retrolxPackages+"/retroarch/usr/share/shaders"
            video_shader = video_shader_dir + "/" + shaderFilename
            commandArray.extend(["--set-shader", video_shader])

        # Generate the append
        if configToAppend:
            commandArray.extend(["--appendconfig", "|".join(configToAppend)])

        # Netplay mode
        if 'netplay.mode' in system.config:
            if system.config['netplay.mode'] == 'host':
                commandArray.append("--host")
            elif system.config['netplay.mode'] == 'client' or system.config['netplay.mode'] == 'spectator':
                commandArray.extend(["--connect", system.config['netplay.server.ip']])
            if 'netplay.server.port' in system.config:
                commandArray.extend(["--port", system.config['netplay.server.port']])
            if 'netplay.nickname' in system.config:
                commandArray.extend(["--nick", system.config['netplay.nickname']])

        # Verbose logs
        commandArray.extend(['--verbose'])

        # Extension used by hypseus .daphne but lr-daphne starts with .zip
        if system.name == 'daphne':
            romName = os.path.splitext(os.path.basename(rom))[0]
            rom = retrolxFiles.daphneDatadir + '/roms/' + romName +'.zip'

        # The libretro core for EasyRPG requires to launch the RPG_RT.ldb file inside the .easyrpg folder
        if system.name == 'easyrpg' and system.config['core'] == "easyrpg":
            rom = rom + '/RPG_RT.ldb'
        
        if system.name == 'scummvm':
            rom = os.path.dirname(rom) + '/' + romName[0:-8]
        
        commandArray.append(rom)
        return Command.Command(array=commandArray)
