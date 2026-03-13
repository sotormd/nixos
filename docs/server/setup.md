# Server Setup

Bootstrap process for the Server role.

Before proceeding, see [Server Requirements](./requirements.md).

# Contents

1. [Obtaining a NixOS Image](#obtaining-a-nixos-image)
2. [Preparing the Device](#preparing-the-device)
3. [Applying Configuration](#applying-configuration)
4. [Setting up Impermanence](#setting-up-impermanence)
5. [Further Reading](#further-reading)

# Obtaining a NixOS Image

1. Build either of the two included images for `aarch64-linux`: SD or SD Remote.

   For more information, see [Images Documentation](../images.md).

2. Write the generated image to a sd-card using `dd` or any equivalent tool.

# Preparing the Device

1. Boot into the newly created sd-card image on the target device.

2. Connect to the internet.

   ```bash
   nmtui
   ```

3. Ensure a working internet connection.

   ```bash
   ping archlinux.org
   ```

4. Set basic environment variables required by the installer.

   ```bash
   export NIXOS_ROLE=server
   ```

# Applying Configuration

1. Clone the flake.

   ```bash
   nixos bootstrap clone
   ```

   The flake will be cloned to `/persist/nixos`.

2. Initialize variables & secrets.

   ```bash
   nixos bootstrap vars
   nixos bootstrap sops
   ```

   Variables and secrets can be configured through environment variables while
   bootstrapping, see [this](#environment-variables) list for all available
   environment variables.

3. Edit variables & secrets.

   ```bash
   nixos edit vars
   nixos edit sops
   ```

   Ensure all variables and secrets are properly defined.

4. Make new configuration the boot default.

   ```bash
   nixos apply boot
   ```

5. Reboot.

   ```bash
   sudo reboot
   ```

## Environment Variables

You _can_ set all variables and secrets while bootstrapping using these
environment variables.

This is useful if you have a `.env` file you wish to export environment
variables from.

Otherwise, it is simpler to edit the variables and secrets files like mentioned
in step 3.

<details>

<summary>Click to expand: full list of possible environment variables</summary>

| Name                      | Explanation                          | Default                                           |
| ------------------------- | ------------------------------------ | ------------------------------------------------- |
| `VARS_DEVICE_HOSTNAME`    | Hostname of the device.              | `$(uname -n)`                                     |
| `VARS_DEVICE_MACHINEID`   | `systemd` machine-id.                | `$(cat /etc/machine-id)`                          |
| `VARS_DEVICE_HOSTID`      | Host ID, required for `ZFS`.         | `$(head -c 8 /etc/machine-id)`                    |
| `VARS_PARTITIONS_ROOT`    | Root partition identifier.           | `"2178694e-02"`                                   |
| `VARS_USER_NAME`          | Username.                            | `$USER`                                           |
| `VARS_USER_EMAIL`         | Email used for git commits.          | `$USER@$VARS_DEVICE_HOSTNAME`                     |
| `VARS_I18N_TIMEZONE`      | Timezone.                            | `$(timedatectl show --property=Timezone --value)` |
| `VARS_I18N_KEYBOARD`      | Keyboard layout.                     | `"us"`                                            |
| `VARS_I18N_LOCALE`        | Locale.                              | `"en_US.UTF-8"`                                   |
| `VARS_NETWORK_INTERFACE`  | Wireless network interface.          | `"wlan0"`                                         |
| `VARS_NETWORK_SSID`       | Wireless network SSID.               | `"net"`                                           |
| `VARS_NETWORK_GATEWAY`    | Network gateway address.             | `"192.168.0.1"`                                   |
| `VARS_NETWORK_ADDRESS`    | Static local IP address.             | `"192.168.0.200"`                                 |
| `VARS_NETWORK_RANGE`      | CIDR range allowed to access server. | `"192.168.0.0/24"`                                |
| `VARS_NETWORK_DOMAIN`     | Server domain.                       | `$VARS_DEVICE_HOSTNAME-server.duckdns.org`        |
| `VARS_NETWORK_SSH_PORT`   | SSH port.                            | `"22"`                                            |
| `VARS_NETWORK_SSH_KEY`    | Allowed public key.                  | (empty)                                           |
| `SECRETS_HASHED_PASSWORD` | Hashed user password.                | (user input)                                      |
| `SECRETS_PSK`             | PSK for the network.                 | (user input)                                      |
| `SECRETS_SEED_KEY`        | Nix key for seed.                    | (randomly generated)                              |
| `SECRETS_DUCKDNS_TOKEN`   | DuckDNS API token.                   | (empty)                                           |
| `SECRETS_SEARXNG_KEY`     | SearXNG secret key.                  | (randomly generated)                              |

Ensure all variables and secrets are properly defined.

</details>

# Setting up Impermanence

> NOTE: This is a post-install action.

1. Populate `/persist/root` with the default directories to persist.

   ```bash
   nixos bootstrap impermanence
   ```

   It is recommended to setup impermanence _after_ services have been set up, so
   that the created directories have the appropriate service owner and group.

   Also note that if any directories were bind mounted using the variables file
   from external disks to the locations where the services expect them to be,
   these have to be re-evaluated. Impermanence creates its own bind mounts, so
   the variables file should be updated to bind mount things from the external
   disks to `/persist/root` instead.

2. Set `impermanence.enable` to `true` in `features` section of the variables
   file.

   ```bash
   nixos edit vars
   ```

3. Make new configuration the boot default.

   ```bash
   nixos apply boot
   ```

4. Reboot.

   ```bash
   sudo reboot
   ```

For more details, see
[Filesystem and Impermanence Documentation](../filesystems.md).

# Further Reading

- [Server Usage Documentation](./usage.md)
