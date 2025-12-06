# `droid` role

Personal [nix-on-droid](https://github.com/nix-community/nix-on-droid)
configuration.

# Contents

[Setup](#setup)

1. [Installing nix-on-droid](#installing-nix-on-droid)
2. [Applying Configuration](#applying-configuration)

[Usage](#usage)

# Setup

## Installing nix-on-droid

1. Install [nix-on-droid](https://f-droid.org/packages/com.termux.nix/) from
   [FDroid](https://f-droid.org/)

2. When prompted, install with flake support.

## Applying Configuration

To rebuild the configuration for the first time:

```bash
nix shell nixpkgs#git --command nix-on-droid switch --flake github:sotormd/nixos
```

# Usage

Switch to the new configuration at `github:sotormd/nixos`:

```bash
switch
```

Garbage collect:

```bash
purge
```
