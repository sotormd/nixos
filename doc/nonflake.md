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

The [CLI](./cli.md) fully supports this with the `NIXOS_NONFLAKE` environment
variable. Setting this variable to `1` will cause the following scripts to use
`nonflake.nix`:

1. `nixos apply`, respects local value for `nixos-rebuild`
2. `nixos build`, respects local value for `nixos-rebuild`
3. `nixos seed`, respects remote value for `nixos-rebuild`
4. `nixos bootstrap`, respects local value for `nixos-install`

For example, what would've looked like:

```bash
nixos-rebuild switch --flake /persist/nixos/flake.nix#machine-workstation-x86_64-linux
```

Now becomes:

```bash
nixos-rebuild switch --file /persist/nixos/nonflake.nix --attr nixosConfigurations.machine-workstation-x86_64-linux
```
