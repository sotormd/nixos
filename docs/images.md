# Images

Three images are offered for `x86_64-linux` architectures:

1. `minimal`: A minimal NixOS environment.

2. `gnome`: NixOS with the GNOME desktop environment.

3. `plasma`: NixOS with the KDE Plasma desktop environment.

The images include several useful packages for installation, recovery, etc.

As with all NixOS installation images, the username for the live session is `nixos` and the password is empty.

# Usage

1. `minimal` image

    ```console
    $ nix run nixpkgs#nixos-generators -- \
    --format iso \
    --flake github:sotormd/nixos#imageMinimal \
    -o /tmp/minimal-image
    ```

2. `gnome` image

    ```console
    $ nix run nixpkgs#nixos-generators -- \
    --format iso \
    --flake github:sotormd/nixos#imageGnome \
    -o /tmp/gnome-image
    ```

3. `plasma` image

    ```console
    $ nix run nixpkgs#nixos-generators -- \
    --format iso \
    --flake github:sotormd/nixos#imagePlasma \
    -o /tmp/plasma-image
    ```
