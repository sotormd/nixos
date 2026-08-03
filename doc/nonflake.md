# Non-Flake Usage

Since NixOS 26.05
[introduced `system.nix`](https://nixos.org/manual/nixos/stable/release-notes#sec-release-26.05-highlights),
we can easily use `nixos-rebuild` with a `--file` and `--attr` and provide our
own `nixpkgs` without relying on `NIX_PATH`.

As a consequence, all the `nixosConfigurations` in this flake can be built
without flakes, using the `nonflake.nix` entrypoint.

Sources are fetched using `fetchTarball` with pins from `flake.lock`, and the
resulting attributes mimic the structure of flake outputs. Using the URLs and
hashes from `flake.lock` avoids having to maintain a separate set of pins, but
any other source of pins could be used instead (for example, `pins.toml`).

This requires no additional changes to the actual modules!

[`mkConfig`](./mkconfig.md) provides a single interface for constructing NixOS
configurations, regardless of whether they are built through `flake.nix` or
`nonflake.nix`.

The [CLI](./cli.md) fully supports this with the `NIXOS_NONFLAKE` environment
variable. Setting this variable to `1` will cause the following scripts to use
`nonflake.nix`:

1. `nixos apply`, respects local value for `nixos-rebuild`
2. `nixos build`, respects local value for `nixos-rebuild`
3. `nixos seed`, respects remote value for `nixos-rebuild`
4. `nixos bootstrap`, respects local value for `nixos-install`

Systems activated with `flake.nix` will automatically have `NIXOS_NONFLAKE=0`,
while systems activated with `nonflake.nix` will have `NIXOS_NONFLAKE=1`. This
ensures subsequent rebuilds use the same entrypoint. The value can still be
overridden by exporting `NIXOS_NONFLAKE` manually.

Internally, what would've looked like this with `NIXOS_NONFLAKE=0`:

```bash
nixos-rebuild switch --flake /persist/nixos/flake.nix#machine-server-x86_64-linux
```

Now becomes this with `NIXOS_NONFLAKE=1`:

```bash
nixos-rebuild switch --file /persist/nixos/nonflake.nix --attr nixosConfigurations.machine-server-x86_64-linux
```

Caveats:

1. `nonflake.nix` only pins direct dependencies (the flake "inputs"). Flakes
   capture a full transitive dependency tree.
2. `flake.nix` symlinks the flake that built the current generation to
   `/etc/current-flake`, this is not available with `nonflake.nix`.
3. `nixos-rebuild` uses `nix-build` (nix2 cli) when used with `--file` and
   `--attr` instead of `nix build` (nix3 cli) used with `--flake`.
