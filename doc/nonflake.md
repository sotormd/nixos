# Non-Flake Usage

> Not recommended, but still works. This is more of a proof-of-concept :p

Since NixOS 26.05 introduced `system.nix`, we can easily use `nixos-rebuild`
with a `--file` and `--attr` and provide our own `nixpkgs` without relying on
`NIX_PATH`.

As a consequence, all the `nixosConfigurations` in this flake can be built
without flakes, using the `nonflake.nix` entrypoint.

Sources are fetched using `fetchTarball` with pins from the `flake.lock` and
expressions are returned in ways which mimic the flake outputs.

This requires no additional changes to the actual modules!

For example for the Laptop role:

> The usual `nixos apply <test|boot|switch>` and `nixos build` do a lot more,
> mainly staging variables and secrets before the rebuild, this has to be done
> manually (eg, with `nixos git add .`)

```bash
nixos-rebuild build --file /persist/nixos/nonflake.nix --attr nixosConfigurations.machine-laptop-x86_64-linux
```

The [CLI](./cli.md) does not support this, and only uses flakes. All other
documentation also assumes flakes.
