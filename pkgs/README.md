# Vendored Packages

Usually because they aren't in Nixpkgs

# Updating

Packages that can be updated are listed in [`can-update`](./can-update), `nixos update`
and GitHub actions update all these pacakges as per their `passthru.updateScript` attributes.

`passthru.updateScript` must be a script that can be invoked from this directory and takes
the package directory name as an argument.

## Updating using the `nixos(1)` CLI

```bash
# for all pkgs
nixos update pkgs

# for specific pkgs only
nixos update pkgs brave xkcd-wall
```

See [CLI Documentation](../doc/cli.md#updating-the-lockfile-and-packages) for more information.

## Updating using the `passthru.updateScript`

```bash
cd pkgs
script=$(nix build -f . brave.passthru.updateScript --no-link --print-out-paths)
"$script" brave
```

## Updating with github actions

Actions will open a PR for package updates.
