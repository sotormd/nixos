# why do I not use _X_?

This flake is by no means a collection of modules that exemplify "best
practices", and it does not aim to be one.

However, I have decided to stay away from several widely used libraries /
modules.

This is in no way to discredit these projects, these are just MY personal
decisions for MY personal setup.

- [home-manager](#home-manager)
- [a wrapper library](#a-wrapper-library)
- [impermanence](#impermanence)
- [stylix](#stylix)
- [disko](#disko)
- [agenix](#agenix)

## home-manager

[link](https://github.com/nix-community/home-manager)

in favor of:

home-manager is a collection of modules which implement several features that
make it easy to interact with a user's `$HOME`.

The three primary features are:

- install packages to the user's environment `home.packages`
- symlink files to the user's home directory `home.file`
- a module system to configure "dotfiles"

1. `home.packages`

   Just use `users.users.<name>.packages`, it does the same thing.

2. `home.file`

   [hjem](https://github.com/feel-co/hjem) is a much simpler symlinker with
   cleaner code.

3. the home-manager module system

   Most dotfiles already have their own configuration language and syntax. Using
   a module system only abstracts this.

   It is far easier to write the configuration in the intended format than rely
   on some downstream abstraction.

   Using an abstraction means that you need to first learn the original
   configuration and then learn the abstraction.

   This is usually fine, _if_ the abstraction provides any advantages. But
   home-manager doesn't do anything that Nix already can't.

4. I believe wrappers are a better way to configure apps

   With home-manager, or any other library that puts configuration in `$HOME`,
   which may be convenient, but the configuration now lives separate from the
   package.

   The solution? wrappers.

   Wrap the package _along_ with its configuration - this way your package only
   relies on what's inside the `/nix/store` and not on things in some
   out-of-store directory like `$HOME`.

   This also provides other benefits, like having multiple versions of the same
   package with different configurations, which wouldn't be trivial if all the
   packages looked for configuration in the same directory under `$HOME`.

   For example if you wanted to use sway with two different configs, you can't
   do this trivially with home-manager, since it creates links in
   `~/.config/sway/config` which every sway package will read.

   But most packages have a `--config` flag or respect xdg environment
   variables. This means that you can create a package that runs
   `sway --config /path/to/config` where the config is some file in the
   `/nix/store`, written using `pkgs.writeTextFile` or something similar.

   Wrappers are how many packages are configured in `nixpkgs`!

   In the cases where I _have_ to write to `$HOME` (example: gtk config), I use
   [hjem](https://github.com/feel-co/hjem) which is a much simpler linker.

## a wrapper library

[example link](https://github.com/lassulus/wrappers)

A wrapper library aims to make the creation and configuration of wrappers easy
and friendly.

I think it's overkill to use a library for something that can be done quite
easily.

`nixpkgs` already provides all the required functions to create a wrapper.

For example, a simple wrapper only needs:

- `pkgs.writeTextFile` to write your configuration
- `pkgs.writeShellScriptBin` to create a script that runs your wrapper
- `pkgs.symlinkJoin` to create the final wrapper package

In fact, several packages in `nixpkgs` are configured this way without a wrapper
library.

I prefer explicit wrappers because they are trivial to audit and already
idiomatic in `nixpkgs` itself.

## impermanence

[link](https://github.com/nix-community/impermanence)

Impermanence provides the `environment.persistence` and `home.persistence`
options that make it easy to set up ephemeral directories on NixOS.

I have found that I can replicate everything that it does with simple systemd
services and bind mounts - a single [lambda](../lib/impermanence.nix) to create
the `fileSystems` blocks.

## stylix

[link](https://github.com/nix-community/stylix)

Stylix aims to make ricing easy, by providing modules that automagically apply
eyecandy configuration for you in a "just works" way.

I use my own colorscheme flake, I believe this gives me the most creative
freedom, rather than using someone else's glorified attr set.

## disko

[link](https://github.com/nix-community/disko)

Disko aims to make disk partitioning and formatting declarative.

This is done by declaring your disk layout in the Nix language and then running
the `disko` package to evaluate it and apply changes.

I have two problems here:

- doesn't do anything that a script can't, other than maybe being able to
  configure everything in the Nix language, which is just another abstraction
- doesn't support dual boot (at least at time of writing)

Disk partitioning is inherently imperative and destructive, so I prefer explicit
scripts over declarative descriptions.

I would like to support dual boot and avoid any unnecessary abstractions, which
I believe I can do best by maintaining my own init scripts.

## agenix

[link](https://github.com/ryantm/agenix)

I use [sops-nix](https://github.com/Mic92/sops-nix), because it doesn't force
age keys upon me.

PSA: using GPG instead of age for encryption is worse in almost every case.
