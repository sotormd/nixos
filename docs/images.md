# Images

[![Build Minimal ISO](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml/badge.svg)](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)
[![Build GNOME ISO](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml/badge.svg)](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml)

Two images are offered for the `x86_64-linux` architecture:

1. `minimal`: A minimal NixOS environment.

2. `gnome`: NixOS with the GNOME desktop environment.

One image is offered for the `aarch64-linux` architecture:

1. `sdcard`: NixOS for sdcard targets (intended for raspberry-pi 4b).

These images have experimental features `flakes` and `nix-command` enabled.

The images include several useful packages for installation, recovery, etc.

As with all NixOS installation images, the username for the live session is
`nixos` and the password is empty.

# Usage

1. `minimal` image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)
   build artifacts.

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#imageMinimal \
   -o /tmp/minimal-image
   ```

   The resultant image will be available inside `/tmp/minimal-image/iso/`.

2. `gnome` image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml)
   build artifacts.

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#imageGnome \
   -o /tmp/gnome-image
   ```

   The resultant image will be available inside `/tmp/gnome-image/iso/`.

3. `sdcard` image

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.imageSD.config.system.build.sdImage
   ```

   The resultant image will be available inside `./result/sd-image/`.

   To build an image for a wireless remote install:

   ```bash
   export SSH_KEY="AAAA..."
   export WIFI_SSID="myNetwork"
   export WIFI_PSK="correct-horse-battery-staple"
   export WIFI_GATEWAY=10.0.0.0
   export WIFI_IP=10.0.0.100
   nix build github:sotormd/nixos#nixosConfigurations.imageSDRemote.config.system.build.sdImage --impure
   ```

   > `--impure` is needed to access environment variables

   Change the environment variables for your environment.

   The resultant image will be available inside `./result/sd-image`.
