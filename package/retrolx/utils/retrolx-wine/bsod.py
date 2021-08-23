#!/usr/bin/python

import psutil

def get_fs_type(mypath):
    root_type = ""
    for part in psutil.disk_partitions():
        if part.mountpoint == '/':
            root_type = part.fstype
            continue
        if mypath.startswith(part.mountpoint):
            return part.fstype
    return root_type

# launcher
fs_userdata = get_fs_type("/userdata")
if fs_userdata not in [ 'ext4', 'btrfs' ]:
    print("\nHowever, Wine is still generating the C: drive structure.\n\nPlease wait a few minutes, it might still work.\n\nAddress dword Dll base\n80125800 kernel32.dll\nCode: 0E : 016F : BBF", "WARNING: Your /userdata partition is formatted as "+fs_userdata+", which might not be fully supported.")
else:
    print("No error has occured.\n\nWine is just generating the C: drive structure.\n\nPlease wait a few minutes.\n\nAddress dword Dll base\n80125800 kernel32.dll\nCode: 0E : 016F : BBF", False)

running = True
#while running:
#    for event in pygame.event.get():
#        if event.type == pygame.QUIT or event.type == pygame.KEYDOWN:
#            running = False
