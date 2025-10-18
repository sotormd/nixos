# scripts

To get a basic overview of available commands:

```console
$ nixos help
```

This document outlines several useful examples, apart from those covered in [README.md](../README.md#nixos-flake-helper).

# Updating the Lockfile

To update all inputs:

```console
$ nixos update
```

To update a specific input:
```console
$ nixos update nixpkgs
```

To update multiple specific inputs:
```console
$ nixos update nixpkgs home-manager
```

After updating the lockfile, you need to test / switch to apply changes.

To switch to the previously committed lockfile:
```console
$ nixos git checkout HEAD flake.lock
```

# Testing a New Configuration

- Does **not** format the flake
- Does **not** fix flake permissions
- Switches to the new configuration
- Does **not** create a boot entry: changes are lost on reboot
- Does **not** create a git commit

```console
$ nixos test
```

To skip the confirmation:
```console
$ yes | nixos test
```

# Switching to a New Configuration

- Formats the flake
- Does **not** fix flake permissions
- Switches to the new configuration
- Creates a boot entry
- Does **not** create a git commit

```console
$ nixos switch
```

To skip the confirmation:
```console
$ yes | nixos switch
```

# Committing a New Configuration

> Not available for `server` role.

- Formats the flake
- Fixes flake permissions
- Switches to the new configuration
- Creates a boot entry
- Creates a git commit

```console
$ nixos commit
```

To skip the confirmation:
```console
$ yes | nixos commit
```

To mention a git commit message:
```console
$ nixos commit -m "docs: update scripts.md"
```

If a message is not mentioned with the `-m` flag, the `$EDITOR` will be opened to ask the user for a git commit message.

# Format the Flake

```console
$ nixos format
```

This is equivalent to running:

```console
$ nixos find . -type f -name '*.nix' -exec nix fmt {} +
```

# Fix Flake Permissions

```console
$ nixos perms
```

This ensures all files are owned by `$USER`, applies `600` to all files, `700` to all directories and `700` to all files under `$NIXOS_DIR/scripts/`.

# Garbage Collect

> WARNING: Destructive command: deletes all non-current generations.

```console
$ nixos purge
```

This iis equivalent to running:
```console
$ nixos sudo nix-collect-garbage --delete-old
```

# Repair the Nix Store

```console
$ nixos repair
```

This is equivalent to running:
```console
$ nixos sudo nix-store --verify --check-contents --repair
```

# Push Local Changes to `server`

> Not available for `server` role.

To push to `server:/nixos`:
```console
$ nixos serverpush /nixos
```

# Edit variables / secrets.

To edit variables:
```console
$ nixos edit vars
```

To edit secrets:
```console
$ nixos edit sops
```

# Miscellaneous

Dispatch any command to `$NIXOS_DIR`:
```console
$ nixos <command>
```

For example:

Add a git remote:
```console
$ nixos git remote add gh git@github:user/repo.git
```

Remove a git remote:
```console
$ nixos git remote remove gh
```

Push to a git remote:
```console
$ nixos git push gh master
```

Remove an accidental commit that hasn't been pushed yet:
```console
$ nixos git reset --soft HEAD~1
```
