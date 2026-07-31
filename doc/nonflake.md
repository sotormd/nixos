# Non-Flake Usage

> Not recommended, but still works. This is more of a proof-of-concept :p

Since NixOS 26.05 introduced `system.nix`, we can easily use `nixos-rebuild`
with a `--file` and `--attr` and provide our own `nixpkgs` without relying on
`NIX_PATH`.

As a consequence, all the `nixosConfigurations` in this flake can be built
without flakes, using the `default.nix` entrypoint. The `default.nix` outputs
expressions in ways which mimic the flake outputs, and require no changes to the
actual modules! Sources are fetched using `fetchTarball` with pins from the
`flake.lock`.

For example for the Laptop role:

> The usual `nixos apply <test|boot|switch>` and `nixos build` do a lot more,
> mainly staging variables and secrets before the rebuild, this has to be done
> manually.

```bash
nixos-rebuild build --file /persist/nixos/default.nix --attr nixosConfigurations.machine-laptop-x86_64-linux
```

The [CLI](./cli.md) does not support this, and only uses flakes. All other
documentation also assumes flakes.
