#!/usr/bin/env python

HOME_INIT = '/usr/share/retrolx/datainit/system/'
HOME = '/userdata/system'
CONF_INIT = HOME_INIT + '/configs'
CONF = HOME + '/configs'
EVMAPY = CONF + '/evmapy'
SAVES = '/userdata/saves'
SCREENSHOTS = '/userdata/screenshots'
BIOS = '/userdata/bios'
OVERLAYS = '/userdata/overlays'
CACHE = '/userdata/system/cache'
ROMS = '/userdata/roms'

esInputs = CONF + '/emulationstation/es_input.cfg'
esSettings = CONF + '/emulationstation/es_settings.cfg'
batoceraConf = HOME + '/retrolx.conf'
logdir = HOME + '/logs/'

from pathlib import Path
arch = Path('/usr/share/retrolx/retrolx.arch').read_text()
retrolxPackages = '/userdata/packages/' + arch

# QT_QPA_PLATFORM should be set accordingly to platform
qt_qpa_platform = 'wayland'
if (arch=="x86_64"):
  qt_qpa_platform = 'xcb'

# This dict is indexed on the emulator name, not on the system
batoceraBins = {
                'libretro'       : retrolxPackages+'/retroarch/usr/bin/retroarch'
              , 'moonlight'      : retrolxPackages+'/moonlight/moonlight'
              , 'mupen64plus'    : retrolxPackages+'/mupen64plus/mupen64plus'
              , 'flycast'        : retrolxPackages+'/flycast/flycast'
              , 'scummvm'        : retrolxPackages+'/scummvm/scummvm'
              , 'vice'           : retrolxPackages+'/vice'
              , 'fsuae'          : retrolxPackages+'/fsuae/fs-uae'
              , 'amiberry'       : retrolxPackages+'/amiberry/amiberry'
              , 'pcsx2'          : retrolxPackages+'/pcsx2/PCSX2'
              , 'pcsx2_avx2'     : retrolxPackages+'/pcsx2_avx2/PCSX2'
              , 'daphne'         : retrolxPackages+'/daphne/hypseus'
              , 'melonds'        : retrolxPackages+'/melonDS/melonDS'
              , 'rpcs3'          : retrolxPackages+'/rpcs3/rpcs3'
              , 'hatari'         : retrolxPackages+'/hatari/hatari'
              , 'supermodel'     : retrolxPackages+'/supermodel/supermodel'
              , 'tsugaru'        : retrolxPackages+'/tsugaru/Tsugaru_CUI'
              , 'xemu'           : retrolxPackages+'/xemu/xemu'
              , 'ppsspp'         : retrolxPackages+'/ppsspp/PPSSPP'
}


retroarchRoot = CONF + '/retroarch'
retroarchRootInit = CONF_INIT + '/retroarch'
retroarchCustom = retroarchRoot + '/retroarchcustom.cfg'
retroarchCoreCustom = retroarchRoot + "/cores/retroarch-core-options.cfg"

libretroExt = '_libretro.so'
screenshotsDir = "/userdata/screenshots/"
savesDir = "/userdata/saves/"

mupenConf = CONF + '/mupen64/'
mupenCustom = mupenConf + "mupen64plus.cfg"
mupenInput = mupenConf + "InputAutoCfg.ini"
mupenSaves = SAVES + "/n64"
mupenMappingUser    = mupenConf + 'input.xml'
mupenMappingSystem  = '/usr/share/retrolx/datainit/system/configs/mupen64/input.xml'

moonlightCustom = CONF+'/moonlight'
moonlightConfigFile = moonlightCustom + '/moonlight.conf'
moonlightGamelist = moonlightCustom + '/gamelist.txt'
moonlightMapping = dict()
moonlightMapping[1] = moonlightCustom + '/mappingP1.conf'
moonlightMapping[2] = moonlightCustom + '/mappingP2.conf'
moonlightMapping[3] = moonlightCustom + '/mappingP3.conf'
moonlightMapping[4] = moonlightCustom + '/mappingP4.conf'

dolphinConfig  = CONF + "/dolphin-emu"
dolphinData    = SAVES + "/dolphin-emu"
dolphinIni     = dolphinConfig + '/Dolphin.ini'
dolphinGfxIni  = dolphinConfig + '/GFX.ini'
dolphinSYSCONF = dolphinData + "/Wii/shared2/sys/SYSCONF"

pcsx2PluginsDir     = retrolxPackages+'/pcsx2/plugins'
pcsx2Avx2PluginsDir = retrolxPackages+'/pcsx2_avx2/plugins'
pcsx2ConfigDir      = "/userdata/system/configs/PCSX2"

fsuaeBios = BIOS
fsuaeConfig = CONF + "/fs-uae"
fsuaeSaves = SAVES + "/amiga"

scummvmSaves = SAVES + '/scummvm'

solarusSaves = SAVES + '/solarus'

viceConfig = CONF + "/vice"

overlaySystem = "/usr/share/retrolx/datainit/decorations"
overlayUser = "/userdata/decorations"
overlayConfigFile = "/userdata/system/configs/retroarch/overlay.cfg"

amiberryRoot = CONF + '/amiberry'
amiberryRetroarchInputsDir = amiberryRoot + '/conf/retroarch/inputs'
amiberryRetroarchCustom = amiberryRoot + '/conf/retroarch/retroarchcustom.cfg'

hatariConf = CONF + '/hatari/hatari.cfg'

daphneConfig = CONF + '/daphne/hypinput.ini'
daphneHomedir = ROMS + '/daphne'
daphneDatadir = '/usr/share/daphne'
daphneSaves = SAVES + '/daphne'

flycastCustom = CONF + '/flycast'
flycastMapping = flycastCustom + '/mappings'
flycastConfig = flycastCustom + '/emu.cfg'
flycastSaves = SAVES + '/dreamcast'
flycastBios = BIOS
flycastVMUBlank = '/usr/lib/python3.10/site-packages/configgen/datainit/dreamcast/vmu_save_blank.bin'
flycastVMUA1 = flycastSaves + '/flycast/vmu_save_A1.bin'
flycastVMUA2 = flycastSaves + '/flycast/vmu_save_A2.bin'

rpcs3Config = CONF
rpcs3Homedir = ROMS + '/ps3'
rpcs3Saves = SAVES
rpcs3CurrentConfig = CONF + '/rpcs3/GuiConfigs/CurrentSettings.ini'
rpcs3config = CONF + '/rpcs3/config.yml'
rpcs3configInput = CONF + '/rpcs3/config_input.yml'
rpcs3configevdev = CONF + '/rpcs3/InputConfigs/Evdev/Default Profile.yml'

supermodelCustom = CONF + '/supermodel'
supermodelIni = supermodelCustom + '/Supermodel.ini'

xemuConfig = CONF + '/xemu/xemu.ini'
