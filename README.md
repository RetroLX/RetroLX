<p align="center">
    <img src="retrolx-logo.png" />
</p>

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
- configs: Configuration files for each userspace target / available architecture.
- package: RetroLX packages (emulators, frontends, support libraries and tools).
- scripts: Helper scripts.

# Build

The current official build environment is Ubuntu 20.10. Additional packages required are documented on the docker image ``RetroLX/ci/docker/Dockerfile``.

How to build is documented by the script ``RetroLX/ci/local/build-retrolx-arch.sh`` that will start the build reusing the currently checkout repository.

Given your environment fullfill the requirements you can build locally. Example call:
```
./build-retrolx-arch.sh ARCH
```

Alternatively the official Docker environment can be used. Example call:
```
./build-retrolx-arch-docker.sh ARCH
```

Where ARCH is one of the available architectures.

The Docker build pipes the output to ``RetroLX/ci/local/docker-output.log`` by default.

The main artifact of the build can be found at: ``RetroLX/output/ARCH/images/retrolx/images/*``.


# Continuous Integration

For every available architecture config file at ``config`` there is an asociated Microsoft Azure build pipeline defined at ``RetroLX/ci/azure``.

The current state for the build of every architecture supported by the master branch can be check at [Azure Pipelines](https://dev.azure.com/retrolx/RetroLX%20images/_build?view=folders).

The current image build of every architecture supported by the master branch can be check at [Retrolx Repository](https://repository.retrolx.org/images/).