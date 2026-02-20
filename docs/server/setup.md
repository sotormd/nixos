# `server` Setup

Bootstrap process for the `server` role.

# Contents

1. [Obtaining a NixOS Image](#obtaining-a-nixos-image)
2. [Preparing the Device](#preparing-the-device)
3. [Applying Configuration](#applying-configuration)
4. [Further Setup](#further-setup)

# Obtaining a NixOS Image

1. Download either of the two included images for `aarch64-linux`: `sd` or
   `sd-remote`. For more information, see [images.md](../images.md).

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
   export NIXOS_DIR=/nixos
   ```

# Applying Configuration

1. Clone the flake.

   ```bash
   nixos init clone
   ```

   The flake will be cloned to `$NIXOS_DIR`.

2. Initialize variables & secrets.

   ```bash
   nixos init vars
   nixos init sops
   ```

   Variables and secrets can be configured through environment variables while
   bootstrapping, see [this](#environment-variables) list for all available
   environment variables.

3. Edit variables & secrets.

   ```bash
   nixos init vars edit
   nixos init sops edit
   ```

   Ensure all variables and secrets are properly defined.

4. Switch to the new configuration.

   ```bash
   nixos switch
   ```

5. Reboot.

   ```bash
   sudo reboot
   ```

   Once you log in with your new username and password, you should be able to
   use the `nixos` command.

## Environment Variables

You _can_ set all variables and secrets while bootstrapping using these
environment variables.

This is useful if you have a `.env` file you wish to export environment
variables from.

Otherwise, it is simpler to edit the variables and secrets files like mentioned
in step 3.

<details>

<summary>Click to expand: full list of possible environment variables</summary>

| Name                                 | Explanation                                        | Default                                           | Example                              |
| ------------------------------------ | -------------------------------------------------- | ------------------------------------------------- | ------------------------------------ |
| `NIXOS_DIR`                          | Directory where the NixOS configuration is stored. | -                                                 | `"/nixos"`                           |
| `NIXOS_ROLE`                         | `laptop` or `server` role                          | -                                                 | `"server"`                           |
| `VARS_DEVICE_HOSTNAME`               | Hostname of the device.                            | `$(uname -n)`                                     | `"Foo"`                              |
| `VARS_DEVICE_MACHINEID`              | `systemd` machine-id.                              | `$(cat /etc/machine-id)`                          | `"51934ba93b754bf28caf413f7e6c65bd"` |
| `VARS_DEVICE_ROOT`                   | Root partition partuuid.                           | `"2178694e-02"`                                   | -                                    |
| `VARS_USER_NAME`                     | Username.                                          | `$USER`                                           | `"Bar"`                              |
| `VARS_USER_EMAIL`                    | Email used for git commits.                        | `"$USER@nixos"`                                   | `"Bar@domain.com"`                   |
| `VARS_I18N_TIMEZONE`                 | Timezone.                                          | `$(timedatectl show --property=Timezone --value)` | `"Europe/Berlin"`                    |
| `VARS_I18N_KEYBOARD`                 | Keyboard layout.                                   | `"us"`                                            | `"us"`                               |
| `VARS_I18N_LOCALE`                   | Locale.                                            | `"en_US.UTF-8"`                                   | `"de_DE.UTF-8"`                      |
| `VARS_NETWORK_INTERFACE`             | Wireless network interface.                        | `"wlp1s0"`                                        | `"wlan0"`                            |
| `VARS_NETWORK_SSID`                  | Wireless network ssid.                             | `"net"`                                           | `"net20"`                            |
| `VARS_NETWORK_GATEWAY`               | Wireless network gateway.                          | `"192.168.0.1"`                                   | `"10.0.0.0"`                         |
| `VARS_NETWORK_RANGE`                 | CIDR allowed to access server.                     | `"192.168.0.0/24"`                                | `"10.0.0.0/24"`                      |
| `VARS_NETWORK_IP`                    | Static local IP address.                           | `"192.168.0.200"`                                 | `"10.0.0.3"`                         |
| `VARS_NETWORK_WPA3_ENABLE`           | Enable SAE (dragonfly) authentication.             | `"true"`                                          | `"false"`                            |
| `VARS_NETWORK_DUCKDNS_DOMAIN`        | DuckDNS domain name.                               | `"$(uname -n)-server.duckdns.org"`                | `"nixos-server-0b123df.duckdns.org"` |
| `VARS_NETWORK_SSH_PORT`              | SSH port.                                          | `"22"`                                            | `"20000"`                            |
| `VARS_NETWORK_SSH_KEY`               | Allowed public key.                                | -                                                 | `"AAAA..."`                          |
| `VARS_NETWORK_UNBOUND_ENABLE`        | Enable Unbound.                                    | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_NGINX_ENABLE`          | Enable Nginx.                                      | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_SEARXNG_ENABLE`        | Enable SearXNG.                                    | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_ENABLE`    | Enable Vaultwarden.                                | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_DATA`      | Vaultwarden data directory.                        | `"/var/lib/bitwarden_rs"`                         | `"/mnt/drive/vaultwarden-data"`      |
| `VARS_NETWORK_VAULTWARDEN_PORT`      | Vaultwarden web vault rocket (loopback) port.      | `"8222"`                                          | `"20001"`                            |
| `VARS_NETWORK_I2PD_ENABLE`           | Enable I2PD.                                       | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_I2PD_SAM_PORT`         | I2PD SAM (loopback) port.                          | `"7656"`                                          | `"20002"`                            |
| `VARS_NETWORK_I2PD_HTTP_PROXY_PORT`  | I2PD HTTP proxy (LAN) port.                        | `"4444"`                                          | `"20003"`                            |
| `VARS_NETWORK_I2PD_SOCKS_PROXY_PORT` | I2PD SOCKS proxy (loopback) port.                  | `"4447"`                                          | `"20004"`                            |
| `VARS_NETWORK_I2PD_WEBCONSOLE_PORT`  | I2PD webconsole (loopback) port.                   | `"7070"`                                          | `"20005"`                            |
| `VARS_NETWORK_QBT_ENABLE`            | Enable qBittorrent.                                | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_QBT_DATA`              | qBittorrent data directory.                        | `"/var/lib/qbt/data"`                             | `"/mnt/drive/qbt"`                   |
| `VARS_NETWORK_QBT_PORT`              | qBittorrent webui (loopback) port.                 | `"8080"`                                          | `"20006"`                            |
| `VARS_NETWORK_JELLYFIN_ENABLE`       | Enable Jellyfin.                                   | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_JELLYFIN_PORT`         | Jellyfin web (loopback) port.                      | `"8096"`                                          | `"20007"`                            |
| `VARS_NETWORK_JELLYFIN_DATA`         | Jellyfin data directory.                           | `"/var/lib/jellyfin"`                             | `"/mnt/drive/jellyfin"`              |
| `SECRETS_HASHED_PASSWORD`            | Hashed user password.                              | `$(mkpasswd -m yescrypt)`                         | -                                    |
| `SECRETS_PSK`                        | PSK for the network.                               | (user input)                                      | `"supersecretpsk"`                   |
| `SECRETS_DUCKDNS_TOKEN`              | DuckDNS API token.                                 | -                                                 | `"aaa..."`                           |
| `SECRETS_SEARXNG_KEY`                | SearXNG secret key.                                | (randomly generated)                              | `"bbb..."`                           |

Ensure all variables and secrets are properly defined.

</details>

# Further Setup

At this stage, this flake has been installed on the device. For further setup,
see:

1. [Usage](./usage.md)

   For using the `server` role.
