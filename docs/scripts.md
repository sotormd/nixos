# scripts

To get a basic overview of available commands:

```bash
nixos help
```

This document outlines several useful examples, apart from those covered in
[README.md](../README.md#nixos-flake-helper).

Additionally, the script is also exposed as the default package of the flake.

so running

```bash
nix run $NIXOS_DIR -- switch
```

is equivalent to

```bash
nixos switch
```

# Contents

1. [Updating the Lockfile](#updating-the-lockfile)
2. [Testing a New Configuration](#testing-a-new-configuration)
3. [Switching to a New Configuration](#switching-to-a-new-configuration)
4. [Committing a New Configuration](#committing-a-new-configuration)
5. [Format the Flake](#format-the-flake)
6. [Fix Flake Permissions](#fix-flake-permissions)
7. [Garbage Collect](#garbage-collect)
8. [Repair the Nix Store](#repair-the-nix-store)
9. [Push Local Changes to server](#push-local-changes-to-server)
10. [Edit variables / secrets](#edit-variables--secrets)
11. [Miscellaneous](#miscellaneous)

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
nixos update nixpkgs home-manager
```

After updating the lockfile, you need to test / switch to apply changes.

To switch to the previously committed lockfile:

```bash
nixos git checkout HEAD flake.lock
```

# Testing a New Configuration

- Does **not** format the flake
- Does **not** fix flake permissions
- Switches to the new configuration
- Does **not** create a boot entry: changes are lost on reboot
- Does **not** create a git commit

```bash
nixos test
```

To skip the confirmation:

```bash
yes | nixos test
```

# Switching to a New Configuration

- Formats the flake
- Does **not** fix flake permissions
- Switches to the new configuration
- Creates a boot entry
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

- Formats the flake
- Fixes flake permissions
- Switches to the new configuration
- Creates a boot entry
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

```
nixos vi .
```
