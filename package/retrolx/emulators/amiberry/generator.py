import os
from os import path
import Command
import retrolxFiles
import shutil
from generators.Generator import Generator
import os.path
import zipfile
from settings.unixSettings import UnixSettings
from generators.libretro import libretroControllers
from os.path import dirname
from utils.logger import eslog

def getGeneratorClass():
    return 'AmiberryGenerator'

class AmiberryGenerator(Generator):

    def generate(self, system, rom, playersControllers, gameResolution):
        retroconfig = UnixSettings(retrolxFiles.amiberryRetroarchCustom, separator=' ')
        if not os.path.exists(dirname(retrolxFiles.amiberryRetroarchCustom)):
            os.makedirs(dirname(retrolxFiles.amiberryRetroarchCustom))
        
        romType = self.getRomType(rom)
        eslog.log("romType: "+romType)
        if romType != 'UNKNOWN' :           
            commandArray = [ retrolxFiles.batoceraBins[system.config['emulator']], "-G" ]
            if romType != 'WHDL' :
                commandArray.append("--model")
                commandArray.append(system.config['core'])
            
            if romType == 'WHDL' :
                commandArray.append("--autoload")
                commandArray.append(rom)
            elif romType == 'HDF' :
                commandArray.append("-s")
                commandArray.append("hardfile2=rw,DH0:"+rom+",32,1,2,512,0,,uae0")
                commandArray.append("-s")
                commandArray.append("uaehf0=hdf,rw,DH0:"+rom+",32,1,2,512,0,,uae0")
            elif romType == 'CD' :
                commandArray.append("--cdimage")
                commandArray.append(rom)
            elif romType == 'DISK':
                # floppies
                n = 0
                for img in self.floppiesFromRom(rom):
                    if n < 4:
                        commandArray.append("-" + str(n))
                        commandArray.append(img)
                    n += 1
                # floppy path
                commandArray.append("-s")
                # Use disk folder as floppy path
                romPathIndex = rom.rfind('/')
                commandArray.append("amiberry.floppy_path="+rom[0:romPathIndex])

            # controller
            libretroControllers.writeControllersConfig(retroconfig, system, playersControllers)
            retroconfig.write()

            if not os.path.exists(retrolxFiles.amiberryRetroarchInputsDir):
                os.makedirs(retrolxFiles.amiberryRetroarchInputsDir)
            nplayer = 1
            for playercontroller, pad in sorted(playersControllers.items()):
                replacements = {'_player' + str(nplayer) + '_':'_'}
                # amiberry remove / included in pads names like "USB Downlo01.80 PS3/USB Corded Gamepad"
                padfilename = pad.realName.replace("/", "")
                playerInputFilename = retrolxFiles.amiberryRetroarchInputsDir + "/" + padfilename + ".cfg"
                with open(retrolxFiles.amiberryRetroarchCustom) as infile, open(playerInputFilename, 'w') as outfile:
                    for line in infile:
                        for src, target in replacements.items():
                            newline = line.replace(src, target)
                            if not newline.isspace():
                                outfile.write(newline)
                if nplayer == 1: # 1 = joystick port
                    commandArray.append("-s")
                    commandArray.append("joyport1_friendlyname=" + padfilename)
                    if romType == 'CD' :
                        commandArray.append("-s")
                        commandArray.append("joyport1_mode=cd32joy")
                if nplayer == 2: # 0 = mouse for the player 2
                    commandArray.append("-s")
                    commandArray.append("joyport0_friendlyname=" + padfilename)
                nplayer += 1

            # fps
            if system.config['showFPS'] == 'true':
                commandArray.append("-s")
                commandArray.append("show_leds=true")

            # disable port 2 (otherwise, the joystick goes on it)
            commandArray.append("-s")
            commandArray.append("joyport2=")

            # display vertical centering
            commandArray.append("-s")
            commandArray.append("gfx_center_vertical=smart")

            os.chdir("/usr/share/amiberry")
            return Command.Command(array=commandArray)
        # otherwise, unknown format
        return Command.Command(array=[])

    def floppiesFromRom(self, rom):
        floppies = []
        
        # split path and extension
        filepath, fileext = path.splitext(rom)
        
        #
        indexDisk = filepath.rfind("(Disk 1")
        
        # from one file (x1.zip), get the list of all existing files with the same extension + last char (as number) suffix
        # for example, "/path/toto0.zip" becomes ["/path/toto0.zip", "/path/toto1.zip", "/path/toto2.zip"]
        if filepath[-1:].isdigit():
            # path without the number
            fileprefix=filepath[:-1]

            # special case for 0 while numerotation can start at 1
            n = 0
            if path.isfile(fileprefix + str(n) + fileext):
                floppies.append(fileprefix + str(n) + fileext)

            # adding all other files
            n = 1
            while path.isfile(fileprefix + str(n) + fileext):
                floppies.append(fileprefix + str(n) + fileext)
                n += 1
        # (Disk 1 of 2) format
        elif indexDisk != -1 :
                # Several disks
                floppies.append(rom)
                prefix = filepath[0:indexDisk+6]
                postfix = filepath[indexDisk+7:]
                n = 2
                while path.isfile(prefix+str(n)+postfix+fileext):
                    floppies.append(prefix+str(n)+postfix+fileext)
                    n += 1                               
        else :        
           #Single ADF
           return [rom]
        
        return floppies
    
    def getRomType(self,filepath) :        
        extension = os.path.splitext(filepath)[1][1:].lower()
        
        if extension == "lha":
            return 'WHDL'
        elif extension == 'hdf' :
            return 'HDF'
        elif extension in ['iso','cue'] :
            return 'CD'
        elif extension in ['adf','ipf']:
            return 'DISK'
        elif extension == "zip":
            # can be either whdl or adf
            with zipfile.ZipFile(filepath) as zip:
                for zipfilename in zip.namelist():
                    if zipfilename.find('/') == -1: # at the root
                        extension = os.path.splitext(zipfilename)[1][1:]
                        if extension == "info":
                            return 'WHDL'
                        elif extension == 'lha' :
                            eslog.log("Amiberry doesn't support .lha inside a .zip")
                            return 'UNKNOWN'
                        elif extension == 'adf' :
                            return 'DISK'
            # no info or adf file found
            return 'UNKNOWN'
        
        return 'UNKNOWN'
