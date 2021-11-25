![RetroLX](retrolx-logo.png)

# RetroLX

RetroLX leverages Linux mainline kernel and open-source emulation projects to bring you a truly customizable retrogaming and/or retrocomputing experience.

RetroLX standard install follows « JeOS » (Just Enough OS) philosophy to be able to accomodate various device ranges it supports. You can then choose and install emulators, game engine ports, and other packages we provide.

RetroLX main technology stack is:
- Linux mainline kernel 5.15.y or newer.
- Buildroot.
- Wayland for ARM / AArch64 devices, Xorg for Intel/AMD x86_64 based computers.
- Pacman package manager.

Find more information about RetroLX at [retrolx.org](https://retrolx.org).

# Repository Structure
- board: Device specific files (patches, bootloader, file system overlay, image generation).
- buildroot: Submodule infrastructure provided by the [Buildroot project](https://buildroot.org/).
- configs: Configuration files for each userspace target.
- package: RetroLX packages (emulators, frontends, support libraries and tools).
- scripts: Helper scripts.

# Build

TODO

# Continuous Integration

TODO