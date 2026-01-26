# scripts

This document covers all included scripts, and the `nixos(1)` unified wrapper.

The documentation for `nixos init` is not included, which is covered in
role-specific bootstrap documentation.

# Contents

1. [Overview](#overview)
2. [Updating the Lockfile](#updating-the-lockfile)
3. [Testing a New Configuration](#testing-a-new-configuration)
4. [Make a New Configuration the Boot Default](#make-a-new-configuration-the-boot-default)
5. [Switching to a New Configuration](#switching-to-a-new-configuration)
6. [Committing a New Configuration](#committing-a-new-configuration)
7. [Format the Flake](#format-the-flake)
8. [Fix Flake Permissions](#fix-flake-permissions)
9. [Garbage Collect](#garbage-collect)
10. [Repair the Nix Store](#repair-the-nix-store)
11. [Push Local Changes to server](#push-local-changes-to-server)
12. [Edit variables / secrets](#edit-variables--secrets)
13. [Miscellaneous](#miscellaneous)
14. [Implementation Details](#implementation-details)

# Overview

Usage:

```bash
nixos [command] [args]
```

To get a basic overview of available commands:

```bash
nixos help
```

For the manpage:

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
nixos vi modules/common/firewall.nix
```

See [Miscellaneous](#miscellaneous) for more cases where this is useful.

Additionally, the script is also exposed as the default package of the flake.

so running

```bash
nix run $NIXOS_DIR -- switch
```

or

```bash
nix run github:sotormd/nixos -- switch
```

is equivalent to

```bash
nixos switch
```

Brief overview of commands:

| Command                 | `laptop` | `server` | Description                                                                                                                                   |
| ----------------------- | -------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `test`                  | ✔        | ✔        | <br>`nixos test` <br>Test the current configuration. Does **not** create a boot entry but activates the configuration.                        |
| `boot`                  | ✔        | ✔        | <br>`nixos boot` <br>Make the current configuration the boot default. Creates a boot entry but doesn't activate the configuration.            |
| `switch`                | ✔        | ✔        | <br>`nixos switch` <br>Switch to the current configuration. Creates a boot entry and activates the configuration.                             |
| `commit [-m <message>]` | ✔        | ✘        | <br>`nixos commit` <br>Switch to and commit the current configuration. Creates a boot entry and a Git commit and activates the configuration. |
| `update [inputs...]`    | ✔        | ✔        | <br>`nixos update` <br>Update flake inputs in `flake.lock`.                                                                                   |
| `format`                | ✔        | ✔        | <br>`nixos format` <br>Format the flake using nixfmt.                                                                                         |
| `perms`                 | ✔        | ✔        | <br>`nixos perms` <br>Apply correct permissions to all files in the flake.                                                                    |
| `purge`                 | ✔        | ✔        | <br>`nixos purge` <br>Garbage collect old generations.                                                                                        |
| `repair`                | ✔        | ✔        | <br>`nixos repair` <br>Attempt to repair the nix store.                                                                                       |
| `edit <vars\|sops>`     | ✔        | ✔        | <br>`nixos edit vars` <br>Edit variables file. <br><br>`nixos edit sops` <br>Edit sops-nix secrets.                                           |
| `serverpush <path>`     | ✔        | ✘        | <br>`nixos serverpush /nixos` <br>Push the flake to `server:/nixos`.                                                                          |
| `help`                  | ✔        | ✔        | <br>`nixos help` <br>Show this message and exit.                                                                                              |

# Updating the Lockfile

To update all inputs:

```bash
nixos update
```

To update a specific input:

```bash
nixos update nixpkgs
```

To update multiple specific inputs:

```bash
nixos update nixpkgs hjem
```

After updating the lockfile, you need to test / switch to apply changes.

To switch to the previously committed lockfile:

```bash
nixos git checkout HEAD flake.lock
```

# Testing a New Configuration

- Activates the new configuration
- Does **not** create a boot entry: changes are lost on reboot
- Does **not** format the flake
- Does **not** fix flake permissions
- Does **not** create a git commit

```bash
nixos test
```

To skip the confirmation:

```bash
yes | nixos test
```

# Make a New Configuration the Boot Default

- Does **not** activate the new configuration
- Creates a boot entry
- Formats the flake
- Does **not** fix flake permissions
- Does **not** create a git commit

```bash
nixos boot
```

To skip the confirmation:

```bash
yes | nixos boot
```

# Switching to a New Configuration

- Activates the new configuration
- Creates a boot entry
- Formats the flake
- Does **not** fix flake permissions
- Does **not** create a git commit

```bash
nixos switch
```

To skip the confirmation:

```bash
yes | nixos switch
```

# Committing a New Configuration

> Not available for `server` role.

- Activates the new configuration
- Creates a boot entry
- Formats the flake
- Fixes flake permissions
- Creates a git commit

```bash
nixos commit
```

To skip the confirmation:

```bash
yes | nixos commit
```

To mention a git commit message:

```bash
nixos commit -m "docs: update scripts.md"
```

If a message is not mentioned with the `-m` flag, the `$EDITOR` will be opened
to ask the user for a git commit message.

Comparison among `test`, `boot`, `switch` and `commit`:

| Command  | Activate new configuration | Create boot entry | Format flake | Fix perms | Create git commit |
| -------- | -------------------------- | ----------------- | ------------ | --------- | ----------------- |
| `test`   | Yes                        | No                | No           | No        | No                |
| `boot`   | No                         | Yes               | Yes          | No        | No                |
| `switch` | Yes                        | Yes               | Yes          | No        | No                |
| `commit` | Yes                        | Yes               | Yes          | Yes       | Yes               |

# Format the Flake

```bash
nixos format
```

This is equivalent to running:

```bash
nixos find . -type f -name '*.nix' -exec nix fmt {} +
```

# Fix Flake Permissions

```bash
nixos perms
```

This ensures all files are owned by `$USER`, applies `600` to all files, `700`
to all directories and `700` to all files under `$NIXOS_DIR/scripts/`.

# Garbage Collect

> WARNING: Destructive command: deletes all non-current generations.

```bash
nixos purge
```

This is equivalent to running:

```bash
sudo nix-collect-garbage --delete-old
```

# Repair the Nix Store

```bash
nixos repair
```

This is equivalent to running:

```bash
sudo nix-store --verify --check-contents --repair
```

# Push Local Changes to `server`

> Not available for `server` role.

To push to `server:/nixos`:

```bash
nixos serverpush /nixos
```

# Edit variables / secrets.

To edit variables:

```bash
nixos edit vars
```

To edit secrets:

```bash
nixos edit sops
```

If you want to recreate the variables / secrets, you can use
`nixos init <vars|sops> replace`.

# Miscellaneous

Dispatch any command to `$NIXOS_DIR`:

```bash
nixos <command>
```

For example:

Add a git remote:

```bash
nixos git remote add gh git@github.com:user/repo.git
```

Remove a git remote:

```bash
nixos git remote remove gh
```

Push to a git remote:

```bash
nixos git push gh master
```

Remove an accidental commit that hasn't been pushed yet:

```bash
nixos git reset --soft HEAD~1
```

Copy the contents of flake.nix

```bash
nixos cat flake.nix | wl-copy
```

Open an editor in the flake directory

```bash
nixos vi .
```

# Implementation Details

All scripts are stored in `$NIXOS_DIR/scripts/`.

The entry point is the `$NIXOS_DIR/scripts/nixos` script, which is mainly a
wrapper for all other scripts.

This wrapper is installed as a package to the system profile.

```console
$ which nixos
/run/current-system/sw/bin/nixos
```

This allows using using `nixos(1)` without installing every individual script as
a package.

The included commands are loaded into the wrapper package's environment
[here](../modules/common/scripts/bin.nix). This is possible because the wrapper
respects the `$NIXOS_SCRIPTS_DIR` environment variable.

`nixos(1)` runs all commands in the `$NIXOS_DIR`, like so:

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

   `nixos(1)` runs `tree $NIXOS_DIR --filesfirst`

2. A script present in `$NIXOS_DIR/scripts/` provided

   ```bash
   nixos switch
   ```

   `nixos(1)` runs `$NIXOS_DIR/scripts/switch`

3. Any other command provided

   ```bash
   nixos cat modules/server/searxng/engines.nix | wl-copy
   ```

   `nixos(1)` dispatches the provided command as-is in `$NIXOS_DIR`

`nixos(1)` also checks that the `$NIXOS_DIR` and `$NIXOS_ROLE` variables are set
and valid.

`nixos(1)` creates a lockfile in `$XDG_RUNTIME_DIR/nixos-script.lock` when the
following commands are used:

- test
- boot
- switch
- commit
- update
- purge
- format
- perms
- init

`nixos(1)` also reports the amount of time taken to finish executing a command:

```console
$ nixos switch
...
...
[nixos] finished in 8s
```

It is _generally_ safe to pipe into and out of the included scripts:

```bash
nixos cat modules/server/searxng/engines.nix | wl-copy
yes | nixos switch
```

All the included scripts were written assuming that they will be called from the
`nixos(1)` wrapper, and not executed directly.

Additionally, there is no need to use `sudo` for any of the included scripts;
the scripts will use `sudo` to elevate privileges when required.
