# Bootstrap Images

Three images are provided for the `x86_64-linux` architecture:

1. **GNOME**: (Installer) NixOS with the GNOME desktop environment.

1. **Minimal**: (Installer) A minimal NixOS environment.

One image is provided for the `aarch64-linux` architecture:

1. **SD**: (Base system) NixOS for the Raspberry Pi 4b.

These images provide a preconfigured environment for setting up this flake, and
include useful tools for installation, recovery, etc.

**For all images, the username is `nixos` and the password is also `nixos`.**

# Contents

1. [Usage](#usage)
2. [Further Configuration](#further-configuration)
3. [Remote Installs](#remote-installs)

# Usage

1. GNOME image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml)
   build artifacts.

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.image-gnome-x86_64-linux.config.system.build.isoImage
   ```

1. Minimal image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)
   build artifacts.

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.image-minimal-x86_64-linux.config.system.build.isoImage
   ```

1. SD image

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.image-sd-aarch64-linux.config.system.build.sdImage
   ```

# Further Configuration

`lib.mkConfig` can also be used to extend the provided images with additional
modules. See example below.

<details>

<summary>Click to expand: Example Usage</summary>

For example, to build a GNOME image with fastfetch installed.

```nix
# flake.nix

{
  description = "example to further configure images";

  # add this flake as an input
  inputs.sotormd-nixos.url = "github:sotormd/nixos";

  outputs = inputs: {
    nixosConfigurations.my-gnome-image = inputs.sotormd-nixos.lib.mkConfig {
      type = "image";
      role = "gnome";
      system = "x86_64-linux";
      extraModules = [
        (
          { pkgs, ... }:
          {
            environment.systemPackages = [ pkgs.fastfetch ];
          }
        )
      ];
    };
  };
}
```

This can then be built normally, like earlier:

```bash
nix build .#nixosConfigurations.my-gnome-image.config.system.build.isoImage
```

</details>

# Remote Installs

It is possible to use `lib.mkConfig` along with the `*-remote` roles to produce
images for remote installs over wireless networks. See example below.

<details>

<summary>Click to expand: Example Usage</summary>

For example, to build a SD image for a Raspberry-Pi for remote installs over a
wireless network:

```nix
# flake.nix

{
  description = "example usage of the image modules";

  # add this flake as an input
  inputs.sotormd-nixos.url = "path:/persist/nixos";

  outputs = inputs: {
    nixosConfigurations.my-remote-sd-image = inputs.sotormd-nixos.lib.mkConfig {
      type = "image";
      role = "sd-remote";
      system = "aarch64-linux";
      extraModules = [
        {
          remote = {
            sshKey = "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA test@test";
            wireless = {
              interface = "wlan0";
              ssid = "example-net";
              psk = "example-psk";
              gateway = "10.0.0.1";
              address = "10.0.0.20";
            };
          };
        }
      ];
    };
  };
}
```

This image can be built normally, like earlier:

```bash
nix build .#nixosConfigurations.my-remote-sd-image.config.system.build.sdImage
```

This image can then be written to the sd card and booted. The installation can
be done through SSH:

```bash
ssh nixos@10.0.0.20
```

</details>
