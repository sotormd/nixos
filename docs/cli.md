# CLI

`nixos(1)` is a unified **wrapper** and general command **dispatcher** for
maintaining this NixOS flake.

This document covers the `nixos(1)` command line interface for `laptop` and
`server` roles.

This document does not cover the usage of `nixos bootstrap` which is covered in
role-specific setup documentation.

# Contents

1. [Overview](#overview)
2. [Applying a new configuration](#applying-a-new-configuration)
3. [Updating the lockfile](#updating-the-lockfile)
4. [Garbage collect](#garbage-collect)
5. [Edit variables and secrets](#edit-variables-and-secrets)
6. [Push local changes](#push-local-changes)
7. [Miscellaneous](#miscellaneous)
8. [Implementation details](#implementation-details)

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

When run with a command not mentioned below, the command is dispatched to
`$NIXOS_DIR`:

```bash
nixos vi modules/machines/common/firewall.nix
```

See [Miscellaneous](#miscellaneous) for more cases where this is useful.

# Applying a new configuration

Safe workflow wrapper around `nixos-rebuild`.

```bash
nixos apply <test|boot|switch>
```

These map to:

```bash
nixos-rebuild <test|boot|switch>
```

The `apply` command does the following extra things:

1. formats the flake
2. fixes flake permissions
3. displays diff since last git commit
4. displays checksum of variables and sops-nix secrets
5. asks user for confirmation before rebuilding
6. ensures variables and sops-nix secrets are unstaged after rebuild

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
   nixos update nixpkgs hjem
   ```

# Garbage collect

> WARNING: Destructive command: deletes all non-current generations.

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
nixos push <host> <path>
```

Examples:

1. To push to `server:/nixos`:

   ```bash
   nixos push server /nixos
   ```

# Miscellaneous

Dispatch any command to `$NIXOS_DIR`:

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

All scripts are stored in `$NIXOS_DIR/cli/`.

The entry point is the `$NIXOS_DIR/cli/nixos` script, which is mainly a wrapper
for all other scripts.

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
- `$NIXOS_DIR` (flake path)
- `$NIXOS_SCRIPTS` (commands path)

`nixos(1)` also passes on these variables to commands as:

- `$__NIXOS_ROLE`
- `$__NIXOS_DIR`
- `$__NIXOS_SCRIPTS`

Also, if `$NIXOS_ROOT_MOUNT` is passed (during bootstrap), then this information
is added to `$NIXOS_DIR` as well.

`nixos(1)` runs all commands (*except `bootstrap`) in the `$NIXOS_DIR`, like so:

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

2. A script present in `$NIXOS_DIR/cli/` provided

   ```bash
   nixos clean
   ```

   `nixos(1)` runs `$NIXOS_DIR/cli/clean`

3. Any other command provided

   ```bash
   nixos cat modules/machines/server/searxng/engines.nix
   ```

   `nixos(1)` dispatches the provided command as-is in `$NIXOS_DIR`

It is _generally_ safe to pipe into and out of the included scripts:

```bash
nixos cat modules/machines/server/searxng/engines.nix | wl-copy
yes | nixos apply switch
```

All the included scripts were written assuming that they will be called from the
`nixos(1)` wrapper, and not executed directly.

Additionally, there is no need to use `sudo` for any of the included scripts;
the scripts will use `sudo` to elevate privileges when required.
