# Bootstrap Images

[![Build GNOME ISO](https://img.shields.io/github/actions/workflow/status/sotormd/nixos/build-gnome-iso.yml?style=for-the-badge&label=Build%20GNOME%20ISO)](https://github.com/sotormd/nixos/actions/workflows/build-gnome-iso.yml)

[![Build Minimal ISO](https://img.shields.io/github/actions/workflow/status/sotormd/nixos/build-minimal-iso.yml?style=for-the-badge&label=Build%20Minimal%20ISO)](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)

Two images are offered for the `x86_64-linux` architecture:

1. **GNOME**: NixOS with the GNOME desktop environment.

2. **Minimal**: A minimal NixOS environment.

One images is offered for the `aarch64-linux` architecture (intended for
Raspberry-Pi 4b):

1. **SD**: NixOS for sdcard targets.

These images have an ideal environment for setting up this flake and also
include several useful packages for installation, recovery, etc.

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
   nix build github:sotormd/nixos#nixosConfigurations.image-gnome.config.system.build.isoImage
   ```

2. Minimal image

   If you do not wish to build this image, you can get one from the
   [Github Actions](https://github.com/sotormd/nixos/actions/workflows/build-minimal-iso.yml)
   build artifacts.

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.image-minimal.config.system.build.isoImage
   ```

3. SD image

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.image-sd.config.system.build.sdImage
   ```

# Further Configuration

It is possible to use the various `nixosModules.image-*` flake outputs to
further configure images.

The available modules are:

- `image-gnome`
- `image-minimal`
- `image-sd`

<details>

<summary>Click to expand: Example</summary>

For example, to build a GNOME image with NH enabled.

```nix
{
  description = "example usage of the image modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-config.url = "github:sotormd/nixos";
  };

  outputs = { self, ... }@inputs: {
    nixosConfigurations.my-gnome-image = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      system = "x86_64-linux";
      modules = [
        inputs.nixos-config.nixosModules.image-gnome
        { programs.nh.enable = true; }
      ];
    };
  };
}
```

This can then be built normally, like earlier:

```bash
nix build .#my-gnome-image.config.system.build.isoImage
```

</details>

# Remote Installs

The `nixosModules-image-*-remote` flake outputs can be used for configuration
images for remote installations over wireless networks.

The only difference between the normal modules is that the remote modules
provide some high-level options to make configuration for remote installations
over wireless networks significantly easier.

The available modules are:

- `image-gnome-remote`
- `image-minimal-remote`
- `image-sd-remote`

<details>

<summary>Click to expand: Example</summary>

For example, to build a SD image for a Raspberry-Pi for remote installs over a
wireless network:

```nix
{
  description = "example usage of the remote image modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-config.url = "github:sotormd/nixos";
  };

  outputs = { self, ... }@inputs: {
    nixosConfigurations.my-remote-sd-image = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      system = "aarch64-linux";
      modules = [
        inputs.nixos-config.nixosModules.image-sd-remote
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
