# Images

Two images are offered for `x86_64-linux` architectures:

1. `minimal`: A minimal NixOS environment.

2. `gnome`: NixOS with the GNOME desktop environment.

These images have experimental features `flakes` and `nix-command` enabled.

The images include several useful packages for installation, recovery, etc.

As with all NixOS installation images, the username for the live session is
`nixos` and the password is empty.

# Usage

1. `minimal` image

   ```console
   $ nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#imageMinimal \
   -o /tmp/minimal-image
   ```

   The resultant image will be available inside `/tmp/minimal-image/iso`.

2. `gnome` image

   ```console
   $ nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#imageGnome \
   -o /tmp/gnome-image
   ```

   The resultant image will be available inside `/tmp/gnome-image/iso`.
