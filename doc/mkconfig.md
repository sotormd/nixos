# `mkConfig` Usage

This document covers `mkConfig`.

`mkConfig` is a configuration builder used throughout this repository. It
provides a single interface for constructing NixOS configurations, regardless of
whether they are built through `flake.nix` or `nonflake.nix`.

It is created by `mkConfigBuilder` from [`./helpers.nix`](../helpers.nix), a
curried function that returns the partially-applied `mkConfig`:

- The outer function provides an interface to pass flake-like values. This is
  used by `flake.nix` and `nonflake.nix`.
- The returned function constructs individual configurations. This is also
  exposed as `lib.mkConfig`.

## `mkConfigBuilder`

`mkConfigBuilder` takes the following arguments in an attr set:

| Attr          | Description                                                                               |
| ------------- | ----------------------------------------------------------------------------------------- |
| `nixos`       | NixOS system evaluation function.                                                         |
| `flakeInputs` | `inputs` for the modules, passed to `specialArgs`.                                        |
| `flakeSelf`   | `self` for the modules, passed to `specialArgs`.                                          |
| `flakeLib`    | `lib` for the modules, passed to `specialArgs` and overlayed as `pkgs.lib`.               |
| `nonflake`    | Whether to enable/disable nonflake-specific things. See [Non-Flake Usage](./nonflake.md). |

For example, here is what `flake.nix` and `nonflake.nix` provide for these
values:

| Attr          | `flake.nix`                                       | `nonflake.nix`                                               |
| ------------- | ------------------------------------------------- | ------------------------------------------------------------ |
| `nixos`       | `inputs.nixpkgs.lib.nixosSystem`                  | `"${pkgs.path}/nixos/lib/eval-config.nix"` from `sources`    |
| `flakeInputs` | `inputs`                                          | A crafted `inputs` which mimics flake inputs, from `sources` |
| `flakeSelf`   | `inputs.self`                                     | A crafted `self` which mimics the flake `inputs.self`        |
| `flakeLib`    | `inputs.nixpkgs.lib` along with [`./lib`](../lib) | `pkgs.lib` along with [`./lib`](../lib)                      |
| `nonflake`    | `false`                                           | `true`                                                       |

> The value of `nonflake` isn't consumed by the actual
> `nixosModules.{modules,profiles,roles}`, but rather by `mkConfig` to configure
> things like the `NIXOS_NONFLAKE` environment variable, and the
> `/etc/current-flake` symlink.

This partially applied function is exposed as `lib.mkConfig`.

As a result, `lib.mkConfig` from `flake.nix` builds flake-based systems, while
`lib.mkConfig` from `nonflake.nix` builds non-flake systems.

## `mkConfig`

`mkConfig` takes the following arguments in an attr set:

| Attr           | Description            | Default                      | Example                              |
| -------------- | ---------------------- | ---------------------------- | ------------------------------------ |
| `role`         | Role                   | -                            | `image-gnome`, `machine-server`, ... |
| `system`       | Platform               | -                            | `x86_64-linux` or `aarch64-linux`    |
| `vars`         | Variables              | `null`                       | `import ./your/variables.nix`        |
| `sops`         | sops-nix Secrets       | `null`                       | `./your/secrets.yaml`                |
| `extraModules` | Extra modules to add   | `[ ]`                        | `[ ./your/module ]`                  |
| `extraInputs`  | Extra attrs for inputs | `{ }`                        | `inputs` from your flake             |
| `extraSelf`    | Extra attrs for self   | `{ }`                        | `self` from your flake               |
| `extraLib`     | Extra attrs for lib    | `{ }`                        | `lib` from your flake                |
| `inputs`       | Inputs (flake-like)    | `flakeInputs // extraInputs` | `your-inputs`                        |
| `self`         | Self (flake-like)      | `flakeSelf // extraSelf`     | `your-inputs.self`                   |
| `lib`          | Library functions      | `flakeLib // extraLib`       | `your-lib`                           |

> `role` corresponds to the various `self.nixosModules.roles.*` available in
> this repository. There is also a `blank` role which imports nothing.

> `inputs`, `self` and `lib` default to the repository's own values and should
> rarely be replaced. Replacing them means taking responsibility for providing
> all of the attributes expected by the exported modules. In most cases,
> additional values should instead be supplied through `extraInputs`,
> `extraSelf`, or `extraLib`.

For example, here is how `lib.mkConfig` is used for two `nixosConfigurations` in
this flake:

| Attr           | `machine-workstation-x86_64-linux` | `image-sd-aarch64-linux` |
| -------------- | ---------------------------------- | ------------------------ |
| `role`         | `"machine-workstation"`            | `"image-sd"`             |
| `system`       | `"x86_64-linux"`                   | `"aarch64-linux"`        |
| `vars`         | `import ./vars/vars.nix`           | default                  |
| `sops`         | `./vars/secrets.yaml`              | default                  |
| `extraModules` | default                            | default                  |
| `extraInputs`  | default                            | default                  |
| `extraSelf`    | default                            | default                  |
| `extraLib`     | default                            | default                  |
| `self`         | default                            | default                  |
| `lib`          | default                            | default                  |

Since every `nixosConfigurations` attr in this repository is built using
`lib.mkConfig`, the same interface can also be used externally to create new
configurations based on the provided roles, add inputs, add modules, or supply
variables and secrets.

## Examples

For example, to extend the `machine-workstation` role with flakes:

```nix
# flake.nix

{
  description = "example to extend machine-workstation";

  # add this flake as an input
  inputs.sotormd-nixos.url = "github:sotormd/nixos";

  outputs = inputs: {
    nixosConfigurations.example = inputs.sotormd-nixos.lib.mkConfig {
      role = "machine-workstation";
      system = "x86_64-linux";
      vars = import ./vars.nix;
      sops = ./secrets.yaml;
      extraModules = [
        ./extra-config.nix # any extra module
        ./some-more-config.nix
      ];
    };
  };
}
```

Or, to extend the `image-minimal` role without flakes, and use existing modules
from this flake:

```nix
# system.nix

# example to extend image-minimal and use existing modules

let
  commit = "f1a406cd6e0d8b7cbeda37d9c0027f0bf14ebc19";
  hash = "0iqn7drd2m1xrnl65193k09l73avlkik8ick335z7qlsg1jf0020";

  source = fetchTarball {
    url = "https://github.com/sotormd/nixos/archive/${commit}.tar.gz";
    sha256 = hash;
  };

  sotormd-nixos = import "${source}/nonflake.nix";

  config = sotormd-nixos.lib.mkConfig {
    role = "image-minimal";
    system = "x86_64-linux";
    extraModules = [
      (
        { self, ... }: # self from sotormd-nixos
        { imports = [ self.nixosModules.modules.boot.quiet ]; }
      )
    ];
  };
in
config
```

Or, to extend the `machine-pi` role with flakes, and use a custom input:

```nix
# flake.nix

{
  description = "example to extend machine-pi with extraInputs";

  # add this flake as an input
  inputs.sotormd-nixos.url = "github:sotormd/nixos";

  # other input
  inputs.neovim.url = "github:sotormd/neovim";

  outputs = inputs: {
    nixosConfigurations.example = inputs.sotormd-nixos.lib.mkConfig {
      role = "machine-pi";
      system = "aarch64-linux";
      vars = import ./vars.nix;
      sops = ./secrets.yaml;
      extraModules = [ ./neovim.nix ];
      extraInputs = { inherit (inputs) neovim; }; # so that we can use inputs.neovim
    };
  };
}
```

```nix
# neovim.nix

{ inputs, ... }: # the inputs include both inputs from sotormd-nix and extraInputs

{
  environment.systemPackages = [ inputs.neovim.packages.aarch64-linux.default ];
}
```
