# Images

[![Build MATE ISO](https://img.shields.io/github/actions/workflow/status/sotormd/nixos/build-mate-iso.yml?style=for-the-badge&label=Build%20MATE%20ISO)](https://github.com/sotormd/nixos/actions/workflows/build-mate-iso.yml)

[![Build GNOME ISO](https://img.shields.io/github/actions/workflow/status/sotormd/nixos/build-gnome-iso.yml?style=for-the-badge&label=Build%20GNOME%20ISO)](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml)

[![Build Minimal ISO](https://img.shields.io/github/actions/workflow/status/sotormd/nixos/build-minimal-iso.yml?style=for-the-badge&label=Build%20Minimal%20ISO)](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)

Three images are offered for the `x86_64-linux` architecture:

1. **MATE**: NixOS with
   [my MATE configuration](https://github.com/sotormd/nixos-mate).

2. **GNOME**: NixOS with the GNOME desktop environment.

3. **Minimal**: A minimal NixOS environment.

Two images are offered for the `aarch64-linux` architecture (intended for
Raspberry-Pi 4b):

1. **SD**: NixOS for sdcard targets.

2. **SD Remote**: Same as SD, but for installation over WiFi.

These images have an ideal environment for setting up this flake and also
include several useful packages for installation, recovery, etc.

For all images, the username is `nixos` and the password is also `nixos`.

# Usage

1. MATE image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-mate-iso.yml)
   build artifacts.

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#image-mate
   ```

2. GNOME image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml)
   build artifacts.

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#image-gnome
   ```

3. Minimal image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)
   build artifacts.

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#image-minimal
   ```

4. SD image

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.image-sd.config.system.build.sdImage
   ```

   The resultant image will be available inside `./result/sd-image/`.

5. SD Remote image

   To build an image for a wireless remote install:

   ```bash
   export SSH_KEY="AAAA..."
   export WIFI_SSID="myNetwork"
   export WIFI_PSK="correct-horse-battery-staple"
   export WIFI_GATEWAY=10.0.0.0
   export WIFI_IP=10.0.0.100
   nix build github:sotormd/nixos#nixosConfigurations.image-sd-remote.config.system.build.sdImage --impure
   ```

   > `--impure` is needed to access environment variables

   Change the environment variables for your environment.

   The resultant image will be available inside `./result/sd-image`.
