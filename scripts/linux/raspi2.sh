#/bin/bash
qemu-system-arm \
	-machine raspi2 -m 1G -smp 4 -cpu cortex-a7 \
	-drive "if=sd,format=raw,file=retrolx-rpi2-2021.08-20211107.img" \
	-kernel output/rpi2/images/zImage \
	-dtb output/rpi2/images/bcm2709-rpi-2-b.dtb \
	-initrd output/rpi2/images/initrd \
	-append "snd_bcm2835.enable_compat_alsa=1 vt.global_cursor_default=0 dev=/dev/mmcblk0p1 rootwait noswap"
