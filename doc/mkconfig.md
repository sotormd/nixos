# `mkConfig` Usage

This document covers `mkConfig`.

`mkConfig` from [`./helpers.nix`](../helpers.nix) is the configuration builder
used throughout this repository. It constructs NixOS configurations from the
modules provided by this flake.

It provides a single interface for constructing NixOS configurations, regardless
of whether they are built through `flake.nix` or `nonflake.nix`.

`mkConfig` is curried:

- The outer function provides an interface to pass flake-like values. This is
  used by `flake.nix` and `nonflake.nix`.
- The returned inner function constructs individual configurations. This is also
  exposed as `lib.mkConfig`.

Outer function takes the following arguments in an attr set:

| Attr          | Description                                                                               |
| ------------- | ----------------------------------------------------------------------------------------- |
| `nixos`       | Entrypoint equivalent of `eval-config.nix`                                                |
| `flakeInputs` | `inputs` for the modules, passed to `specialArgs`                                         |
| `flakeSelf`   | `self` for the modules, passed to `specialArgs`                                           |
| `flakeLib`    | `lib` for the modules, passed to `specialArgs` and overlayed as `pkgs.lib`                |
| `nonflake`    | Whether to enable/disable nonflake-specific things. See [Non-Flake Usage](./nonflake.md). |

For example, here is what `flake.nix` and `nonflake.nix` provide for these
values:

| Attr          | `flake.nix`                                       | `nonflake.nix`                                               |
| ------------- | ------------------------------------------------- | ------------------------------------------------------------ |
| `nixos`       | `lib.nixosSystem` from `inputs.nixpkgs`           | `"${pkgs.path}/nixos/lib/eval-config.nix"` from `sources`    |
| `flakeInputs` | `inputs`                                          | A crafted `inputs` which mimics flake inputs, from `sources` |
| `flakeSelf`   | `inputs.self`                                     | A crafted `self` which mimics the flake `inputs.self`        |
| `flakeLib`    | `inputs.nixpkgs.lib` along with [`./lib`](../lib) | `pkgs.lib` along with [`./lib`](../lib)                      |
| `nonflake`    | `false`                                           | `true`                                                       |

> The value of `nonflake` isn't consumed by the actual
> `nixosModules.{modules,profiles,roles}`, but rather by `mkConfig` to configure
> things like the `NIXOS_NONFLAKE` environment variable, and the
> `/etc/current-flake` symlink.

The outer function returns the configuration builder exposed as `lib.mkConfig`.

As a result, `lib.mkConfig` from `flake.nix` builds flake-based systems, while
`lib.mkConfig` from `nonflake.nix` builds non-flake systems.

This inner function takes the following arguments in an attr set:

| Attr           | Description          | Default       | Example                           |
| -------------- | -------------------- | ------------- | --------------------------------- |
| `type`         | Type of role         | -             | `image` or `machine`              |
| `role`         | Name of role         | -             | `gnome`, `server`, `sd`, ...      |
| `system`       | Platform             | -             | `x86_64-linux` or `aarch64-linux` |
| `vars`         | Variables            | `null`        | `import ./your/variables.nix`     |
| `sops`         | sops-nix Secrets     | `null`        | `./your/secrets.yaml`             |
| `extraModules` | Extra modules to add | `[ ]`         | `[ ./your/module ]`               |
| `inputs`       | Inputs (flake-like)  | `flakeInputs` | `your-inputs`                     |
| `self`         | Self (flake-like)    | `flakeSelf`   | `your-inputs.self`                |
| `lib`          | Library functions    | `flakeLib`    | `your-lib`                        |

> `type` and `role` correspond to directories under [`./roles`](../roles). For
> example, `type = "machine"` and `role = "server"` selects
> `./roles/machine-server`.

For example, here is how `lib.mkConfig` is used for two `nixosConfigurations` in
this flake:

| Attr           | `machine-workstation-x86_64-linux` | `image-sd-aarch64-linux` |
| -------------- | ---------------------------------- | ------------------------ |
| `type`         | `"machine"`                        | `"image"`                |
| `role`         | `"workstation"`                    | `"sd"`                   |
| `system`       | `"x86_64-linux"`                   | `"aarch64-linux"`        |
| `vars`         | `import ./vars/vars.nix`           | default                  |
| `sops`         | `./vars/secrets.yaml`              | default                  |
| `extraModules` | default                            | default                  |
| `self`         | default                            | default                  |
| `lib`          | default                            | default                  |

Since every `nixosConfiguration` in this repository is built using
`lib.mkConfig`, the same interface can also be used externally to create new
configurations based on the provided roles, override inputs, add modules, or
supply variables and secrets.

For example, to extend the `machine-workstation` role:

```nix
# flake.nix

{
  description = "example to extend machine-workstation";

  # add this flake as an input
  inputs.sotormd-nixos.url = "github:sotormd/nixos";

  outputs = inputs: {
    nixosConfigurations.example = inputs.sotormd-nixos.lib.mkConfig {
      type = "machine";
      role = "workstation";
      system = "x86_64-linux";
      vars = import ./vars.nix;
      sops = ./secrets.yaml;
      extraModules = [
        ./extra-config.nix
        ./some-more-config.nix
        ({ pkgs, ... }: { environment.systemPackages = [ pkgs.fastfetch ]; })
      ];
    };
  };
}
```

An example of extending an image is provided in the
[Images Documentation](./images.md#further-configuration).
