# pkgs

vendored packages, usually because they aren't in Nixpkgs

1. brave browser
2. xkcd-wall

# updating

packages that need to be updated are listed in [`to-update`](./to-update), `nixos update`
and gh actions update all these pacakges as per their `passthru.updateScript` attributes.

`passthru.updateScript` must be a script that can be invoked from this directory and takes
the package directory name as an argument.

## updating using the `nixos(1)` cli

```bash
nixos update
```

## updating using the `passthru.updateScript`

```bash
cd pkgs
script=$(nix build -f . brave.passthru.updateScript --no-link --print-out-paths)
"$script" brave
```

## updating with github actions

actions will open a PR for package updates
