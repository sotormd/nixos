# CLI

`nixos(1)` is a bespoke unified **wrapper** and general command **dispatcher**
for maintaining this NixOS flake.

This document covers the `nixos(1)` command line interface for Laptop and Server
roles.

This document does not cover the usage of `nixos bootstrap` which is covered in
role-specific setup documentation.

# Contents

1. [Overview](#overview)
2. [Applying a new configuration](#applying-a-new-configuration)
3. [Building a new configuration](#building-a-new-configuration)
4. [Updating the lockfile](#updating-the-lockfile)
5. [Garbage collect](#garbage-collect)
6. [Edit variables and secrets](#edit-variables-and-secrets)
7. [Push local changes](#push-local-changes)
8. [Build remote closures](#build-remote-closures)
9. [Miscellaneous](#miscellaneous)
10. [Implementation details](#implementation-details)

# Overview

Usage:

```bash
nixos [command] [args]
```

A manpage is available at:

```bash
man nixos
```

When run with no commands, equivalent to:

```bash
nixos tree --filesfirst
```

When run with a command not mentioned below, the command is dispatched to the
flake directory `/persist/nixos`:

```bash
nixos vi modules/machines/common/firewall.nix
```

See [Miscellaneous](#miscellaneous) for more cases where this is useful.

# Applying a new configuration

Safe workflow wrapper around `nixos-rebuild <test|boot|switch>`.

```bash
nixos apply <test|boot|switch>
```

These map to:

```bash
nixos-rebuild <test|boot|switch>
```

The `apply` command does the following extra things:

1. stages changes to git
2. displays diff since last git commit
3. displays checksum of variables and sops-nix secrets
4. asks user for confirmation before rebuilding
5. ensures variables and sops-nix secrets are unstaged after rebuild

| Command  | Activate Configuration | Boot Entry |
| -------- | ---------------------- | ---------- |
| `test`   | Yes                    | No         |
| `boot`   | No                     | Yes        |
| `switch` | Yes                    | Yes        |

For a detailed comparision of `test`, `boot` and `switch`: see
`nixos-rebuild(8)`

Examples:

1. Switch to the new configuration

   ```bash
   nixos apply switch
   ```

2. Make the new configuration the boot default, and skip confirmation:

   ```bash
   yes | nixos apply boot
   ```

# Building a new configuration

Safe workflow wrapper around `nixos-rebuild build`.

```bash
nixos build
```

The `build` command does the following extra things:

1. stages changes to git
2. ensures variables and sops-nix secrets are unstaged after rebuild

For a detailed description of `nixos-rebuild build`: see `nixos-rebuild(8)`

Examples:

1. Build new configuration

   ```bash
   nixos build
   ```

# Updating the lockfile

Update lockfile inputs in `flake.lock`.

```bash
nixos update [inputs...]
```

This is equivalent to:

```bash
nixos nix flake update [inputs...]
```

Examples:

1. To update all inputs:

   ```bash
   nixos update
   ```

2. To update a specific input:

   ```bash
   nixos update nixpkgs
   ```

3. To update multiple specific inputs:

   ```bash
   nixos update nixpkgs sops-nix lanzaboote
   ```

# Garbage collect

> Destructive command: deletes all non-current generations.

```bash
nixos clean
```

This is equivalent to running:

```bash
sudo nix-collect-garbage --delete-old
```

# Edit variables and secrets

Open variables or sops-nix secrets in `$EDITOR`.

```bash
nixos edit <vars|sops>
```

Examples:

1. To edit variables:

   ```bash
   nixos edit vars
   ```

2. To edit secrets:

   ```bash
   nixos edit sops
   ```

# Push local changes

Push local changes to a remote host using `rsync` over `ssh`.

```bash
nixos push <host>
```

Examples:

1. To push to host `foobar`:

   ```bash
   nixos push foobar
   ```

# Build remote closures

Build, sign and copy a remote host's closure.

```bash
nixos seed [host]
```

If no host is specified, prints the builder’s public key for trusting on remote
hosts.

For seeding to work, the following are required:

- On the builder:

  1. A private Nix key in the sops-nix secrets. This is automatically generated
     during bootstrap.

- On the remote:

  1. `vars.seed.enable` should be set to `true`
  2. The builder's public key should be added to `vars.seed.trusted-keys`.

Examples:

1. To seed the host `foobar`:

   ```bash
   nixos seed foobar
   ```

2. To copy the public key of the current host:

   ```bash
   nixos seed | wl-copy
   ```

3. To update the flake, push changes to `foobar`, seed `foobar` and switch
   `foobar`:

   ```console
   $ nixos update
   $ nixos push foobar
   $ nixos seed foobar
   $ ssh foobar
   [foobar]$ nixos apply switch
   [foobar]$ exit
   $
   ```

# Miscellaneous

Dispatch any command to flake directory `/persist/nixos`:

```bash
nixos <command>
```

Examples:

1. Open an editor in the flake directory

   ```bash
   nixos vi .
   ```

1. Add a git remote:

   ```bash
   nixos git remote add gh git@github.com:user/repo.git
   ```

1. Push to a git remote:

   ```bash
   nixos git push gh master
   ```

1. Remove an accidental commit that hasn't been pushed yet:

   ```bash
   nixos git reset --soft HEAD~1
   ```

1. Copy the contents of flake.nix

   ```bash
   nixos cat flake.nix | wl-copy
   ```

# Implementation details

All scripts are stored in `/persist/nixos/cli/scripts`.

The entry point is the `/persist/nixos/cli/nixos` script, which is mainly a
wrapper for all other scripts.

This wrapper is installed as a package to the system profile.

```console
$ which nixos
/run/current-system/sw/bin/nixos
```

A store path with all the other commands are created and passed to the wrapper
using the `$NIXOS_SCRIPTS` environment variable.

Additionally, `nixos(1)` also evaluates that the values for the following
variables make sense:

- `$NIXOS_ROLE` (configuration role)
- `$NIXOS_MOUNT` (used for bootstrap)
- `$NIXOS_SCRIPTS` (commands path)

`nixos(1)` also passes on these variables to commands as:

- `$__NIXOS_ROLE`
- `$__NIXOS_MOUNT`
- `$__NIXOS_SCRIPTS`

`nixos(1)` also passes on some globals to commands:

- `$__NIXOS_GLOBALS_FLAKE`, the flake directory `/persist/nixos`
- `$__NIXOS_GLOBALS_SOPS`, the sops-nix GnuPG home `/persist/sops-nix`
- `$__NIXOS_GLOBALS_IMPERMANENCE`, the Impermanence directory, `/persist/root`

`nixos(1)` runs all commands (*except `bootstrap`) in the flake directory
`/persist/nixos`, like so:

```bash
(
	cd $DIR || exit 1
	"${cmd[@]}"
)
```

When a command is passed, as in `nixos [command] [args]`, it looks for this
command in three places:

1. No command provided

   ```bash
   nixos
   ```

   `nixos(1)` runs `tree --filesfirst`

2. A script present in `/persist/nixos/cli/scripts` provided

   ```bash
   nixos clean
   ```

   `nixos(1)` runs `/persist/nixos/cli/scripts/clean` in `/persist/nixos`

3. Any other command provided

   ```bash
   nixos cat modules/machines/server/searxng/engines.nix
   ```

   `nixos(1)` dispatches the provided command as-is in `/persist/nixos`

It is _generally_ safe to pipe into and out of the included scripts **except**
`nixos bootstrap`:

```bash
nixos cat modules/machines/server/searxng/engines.nix | wl-copy
yes | nixos apply switch
```

**The output of `nixos bootstrap` IS NOT STABLE and should not be used for
scripting.**

All the included scripts were written assuming that they will be called from the
`nixos(1)` wrapper, and not executed directly.

Additionally, there is no need to use `sudo` / `run0` for any of the included
scripts; the scripts will use `sudo` / `run0` to elevate privileges when
required.
