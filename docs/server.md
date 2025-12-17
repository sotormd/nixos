# `server` role

Personal home-server configuration.

**Intended for Raspberry Pi hosts using the NixOS aarch64 sd card image.**

# Contents

[Setup](#setup)

1. [Obtaining a NixOS Image](#obtaining-a-nixos-image)
2. [Preparing the Device](#preparing-the-device)
3. [Applying Configuration](#applying-configuration)

[Usage](#usage)

1. [System Maintenance](#system-maintenance)
2. [Services](#services)
3. [Adding External Disks](#adding-external-disks)

[Security & Privacy](#security--privacy)

# Setup

Bootstrap process for the `server` role.

## Obtaining a NixOS Image

1. Get a NixOS sd-card image that has experimental features `flakes` and
   `nix-command` enabled.

   One such images is included in this flake. To use the included image:

   ```bash
   nix build github:sotormd/nixos#nixosConfigurations.imageSD.config.system.build.sdImage
   ```

   The generated image will be available under `./result/sd-image/`.

   There is also a remote image for wireless installs over SSH.

   For more information, see [images.md](./images.md).

2. Write the generated image to a sd-card using `dd` or any equivalent tool.

## Preparing the Device

1. Boot into the newly created sd-card image on the target device.

2. Connect to the internet.

   ```bash
   nmtui
   ```

3. Ensure a working internet connection.

   ```bash
   ping archlinux.org
   ```

4. Set the role.

   ```bash
   export NIXOS_ROLE=server
   ```

## Applying Configuration

1. Set the directory to install the flake.

   ```bash
   export NIXOS_DIR=/nixos
   ```

2. Clone the flake.

   ```bash
   nix run github:sotormd/nixos -- init clone
   ```

   The flake will be cloned to `$NIXOS_DIR`.

3. Initialize variables & secrets.

   ```bash
   nix run github:sotormd/nixos -- init vars
   nix run github:sotormd/nixos -- init sops
   ```

   Variables and secrets can be configured through environment variables while
   bootstrapping, see [this](#environment-variables) list for all available
   environment variables.

4. Edit variables & secrets.

   ```bash
   nix run github:sotormd/nixos -- init vars edit
   nix run github:sotormd/nixos -- init sops edit
   ```

   Ensure all variables and secrets are properly defined.

5. Switch to the new configuration.

   ```bash
   nix run github:sotormd/nixos -- switch
   ```

6. Reboot.

   ```bash
   sudo reboot
   ```

   Once you log in with your new username and password, you should be able to
   use the `nixos` command.

### Environment Variables

You _can_ set all variables and secrets while bootstrapping using these
environment variables.

This is useful if you have a `.env` file you wish to export environment
variables from.

Otherwise, it is simpler to edit the variables and secrets files like mentioned
in step 4.

<details>

<summary>Click to expand: full list of possible environment variables</summary>

| Name                                      | Explanation                                        | Default                                           | Example                              |
| ----------------------------------------- | -------------------------------------------------- | ------------------------------------------------- | ------------------------------------ |
| `NIXOS_DIR`                               | Directory where the NixOS configuration is stored. | -                                                 | `"/nixos"`                           |
| `NIXOS_ROLE`                              | `laptop` or `server` role                          | -                                                 | `"server"`                           |
| `VARS_DEVICE_HOSTNAME`                    | Hostname of the device.                            | `$(uname -n)`                                     | `"Foo"`                              |
| `VARS_DEVICE_MACHINEID`                   | `systemd` machine-id.                              | `$(cat /etc/machine-id)`                          | `"51934ba93b754bf28caf413f7e6c65bd"` |
| `VARS_DEVICE_ROOT`                        | Root partition partuuid.                           | -                                                 | -                                    |
| `VARS_USER_NAME`                          | Username.                                          | `$USER`                                           | `"Bar"`                              |
| `VARS_USER_EMAIL`                         | Email used for git commits.                        | -                                                 | `"Bar@domain.com"`                   |
| `VARS_I18N_TIMEZONE`                      | Timezone.                                          | `$(timedatectl show --property=Timezone --value)` | `"Europe/Berlin"`                    |
| `VARS_I18N_KEYBOARD`                      | Keyboard layout.                                   | `"us"`                                            | `"us"`                               |
| `VARS_I18N_LOCALE`                        | Locale.                                            | `"en_US.UTF-8"`                                   | `"de_DE.UTF-8"`                      |
| `VARS_NETWORK_INTERFACE`                  | Wireless network interface.                        | `"wlp1s0"`                                        | `"wlan0"`                            |
| `VARS_NETWORK_SSID`                       | Wireless network ssid.                             | -                                                 | `"net20"`                            |
| `VARS_NETWORK_GATEWAY`                    | Wireless network gateway.                          | `"192.168.0.1"`                                   | `"10.0.0.0"`                         |
| `VARS_NETWORK_RANGE`                      | CIDR allowed to access server.                     | `"192.168.0.0/24"`                                | `"10.0.0.0/24"`                      |
| `VARS_NETWORK_IP`                         | Static local IP address.                           | -                                                 | `"10.0.0.3"`                         |
| `VARS_NETWORK_WPA3_ENABLE`                | Enable SAE (dragonfly) authentication.             | `"true"`                                          | `"false"`                            |
| `VARS_NETWORK_DUCKDNS_DOMAIN`             | DuckDNS domain name.                               | `"$(uname -n)-server.duckdns.org"`                | `"nixos-server-0b123df.duckdns.org"` |
| `VARS_NETWORK_SSH_PORT`                   | SSH port.                                          | `"22"`                                            | `"20000"`                            |
| `VARS_NETWORK_SSH_KEY`                    | Allowed public key.                                | -                                                 | `"AAAA..."`                          |
| `VARS_NETWORK_UNBOUND_ENABLE`             | Enable Unbound.                                    | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_NGINX_ENABLE`               | Enable Nginx.                                      | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_SEARXNG_ENABLE`             | Enable SearXNG.                                    | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_ENABLE`         | Enable Vaultwarden.                                | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_DATA`           | Vaultwarden data directory.                        | `"/var/lib/bitwarden_rs"`                         | `"/mnt/drive/vaultwarden-data"`      |
| `VARS_NETWORK_VAULTWARDEN_PORT`           | Vaultwarden web vault rocket (loopback) port.      | `"8222"`                                          | `"20001"`                            |
| `VARS_NETWORK_I2PD_ENABLE`                | Enable I2PD.                                       | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_I2PD_SAM_PORT`              | I2PD SAM (loopback) port.                          | `"7656"`                                          | `"20002"`                            |
| `VARS_NETWORK_I2PD_HTTP_PROXY_PORT`       | I2PD HTTP proxy (LAN) port.                        | `"4444"`                                          | `"20003"`                            |
| `VARS_NETWORK_I2PD_SOCKS_PROXY_PORT`      | I2PD SOCKS proxy (loopback) port.                  | `"4447"`                                          | `"20004"`                            |
| `VARS_NETWORK_I2PD_WEBCONSOLE_PROXY_PORT` | I2PD webconsole (loopback) port.                   | `"7070"`                                          | `"20005"`                            |
| `VARS_NETWORK_QBT_ENABLE`                 | Enable qBittorrent.                                | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_QBT_DATA`                   | qBittorrent data directory.                        | `"/var/lib/qbt/data"`                             | `"/mnt/drive/qbt"`                   |
| `VARS_NETWORK_QBT_PORT`                   | qBittorrent webui (loopback) port.                 | `"8080"`                                          | `"20006"`                            |
| `VARS_NETWORK_JELLYFIN_ENABLE`            | Enable Jellyfin.                                   | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_JELLYFIN_PORT`              | Jellyfin web (loopback) port.                      | `"8096"`                                          | `"20007"`                            |
| `SECRETS_HASHED_PASSWORD`                 | Hashed user password.                              | `$(mkpasswd -m yescrypt)`                         | -                                    |
| `SECRETS_PSK`                             | PSK for the network.                               | (user input)                                      | `"supersecretpsk"`                   |
| `SECRETS_DUCKDNS_TOKEN`                   | DuckDNS API token.                                 | -                                                 | `"aaa..."`                           |
| `SECRETS_SEARXNG_KEY`                     | SearXNG secret key.                                | (randomly generated)                              | `"bbb..."`                           |

Ensure all variables and secrets are properly defined.

</details>

# Usage

Using the `server` role.

## System Maintenance

Routine tasks such as updating the flake, switching configurations,
garbage-collecting, repairing the Nix store, and editing variables & secrets are
handled through the unified `nixos` helper script.

To see all commands:

```bash
nixos help
```

See [scripts.md](./scripts.md) for the full command reference and workflow
examples.

## Services

Services can be enabled / disabled / configured in the variables file. To edit
the variables file:

```bash
nixos edit vars
```

### SSH

sshd secure shell daemon.

Exposes one port to `vars.network.range`: `vars.network.ssh.port`.

Trusted public keys are defined in `vars.network.ssh.keys`.

The hardened configuration can be found
[here](../modules/server/ssh/settings.nix).

### Unbound

Unbound is a recursive validating DNS server.

Enabled using `vars.network.unbound.`

Exposes two ports to `vars.network.range`: `53/tcp` `53/udp`.

The hardened configuration can be found
[here](../modules/server/unbound/settings.nix).

### nginx

Nginx is a web server and reverse proxy.

Enabled using `vars.network.nginx.enable`.

Exposes one port to `vars.network.range`: `443`.

#### Domain

The nginx web server is hosted at `https://<your-duckdns-domain>`.

The DuckDNS domain is declared using `vars.network.duckdns.domain`.

It attempts to fetch a Let's Encrypt HTTPS certificate with a DNS-01 challenge
using your duckdns domain.

#### Reverse Proxy

The root of the web server returns a
[homepage](https://github.com/sotormd/homepage) with links to all the services'
reverse proxy pages.

Reverse proxy is set up for the following services, if enabled:

| Location       | Name                  | Description                 |
| -------------- | --------------------- | --------------------------- |
| `/searxng`     | SearXNG               | Search engine               |
| `/vaultwarden` | Vaultwarden web vault | Password manager            |
| `/i2pd`        | I2PD web console      | Invisible Internel Protocol |
| `/qbt`         | qBittorrent webui     | Bittorrent client           |
| `/jellyfin`    | Jellyfin              | Media server                |

### SearXNG

SearXNG is a fast, private metasearch engine.

Enabled using `vars.network.searxng.enable`.

Doesn't expose any ports since it uses `uwsgi`.

The full list of enabled search engines can be found
[here](../modules/server/searxng/engines.nix).

### Vaultwarden

Vaultwarden is a password manager.

Enabled using `vars.network.vaultwarden.enable`.

Exposes one port to the loopback interface: `vars.network.vaultwarden.port`.

Data directory is declared by `vars.network.vaultwarden.data`.

### I2PD

I2PD is a router for the I2P network.

Enabled using `vars.network.i2pd.enable`.

Exposes three ports to the loopback interface:
`vars.network.i2pd.webconsole.port` `vars.network.i2pd.socksProxy.port`
`vars.network.i2pd.sam.port`.

Exposes one port to `vars.network.range`: `vars.network.i2pd.httpProxy.port`.

### qBittorrent

qBittorrent-nox is a web interface for the qBittorrent bittorrent client.

Enabled using `vars.network.qbt.enable`.

Exposes one port to the loopback interface: `vars.network.qbt.port`.

Data directory is declared by `vars.network.qbt.data`.

#### Initial Setup

qBittorrent will initially start with username `admin` and a random password.
Check the service status for the password.

```bash
systemctl status qbt
```

Then, in the web ui `https://<your-duckdns-domain>/qbt` under
`Tools > Options > WebUI > Authentication` set a username and password.

#### Categories

Two categories, `Movies` and `TV`, are created by default.

### Jellyfin

Jellyfin is a media server.

Enabled using `vars.network.jellyfin.enable`.

Exposes one port to the loopback interface: `vars.network.jellyfin.port`.

#### Initial Setup

Access the web interface at `https://<your-duckdns-domain>/jellyfin` and follow
the wizard to set up your user and library.

#### Disabling media playback

If using only the `Download` and/or `Copy Stream URL` options, you can disable
media playback by disallowing it for your user.

1. Access the web interface at `https://<your-duckdns-domain>/jellyfin`

2. Uncheck `Allow media playback` under
   `Dashboard > Users > <your-user> > Profile > Media Playback`.

3. Click `Save` at the end of the page.

## Adding External Disks

External disks - whether **unencrypted**, **LUKS-encrypted**, or **requiring
hdparm tweaks** - can be configured declaratively through `vars.nix`.

Open the variables file:

```bash
nixos edit vars
```

All configuration happens under the `device.*` sections.

### Unencrypted Disks (device.mount)

Use `device.mount` to configure _plain, unencrypted_ filesystems.

Each attribute key is the mount point, and the value describes the underlying
block device.

#### Example

```nix
device.mount = {
  "/mnt/media" = {
    device = "/dev/disk/by-uuid/243fdae5-89df-4407-e6163e688f4d";
    fsType = "xfs";
    options = [ "defaults" ];
    neededForBoot = false;
  };

  "/mnt/backup" = {
    device = "/dev/disk/by-partuuid/1b2c3d4e-55ff-8899-aabb-ccddeeff0011";
    fsType = "ext4";
    options = [ "noatime" ];
    neededForBoot = false;
  };
};
```

These are translated directly into `fileSystems` entries during system
generation.

### LUKS-Encrypted Disks (device.luks)

Use `device.luks` to define encrypted volumes that unlock using a keyfile.

Each entry requires:

- `uuid` - LUKS container UUID (`blkid` output)
- `keyfile` - path to keyfile
- `mount` - where the decrypted mapper device should mount
- `fs` - filesystem inside the LUKS container (`ext4`, `xfs`, etc.)

#### Example

```nix
device.luks = {
  ht02 = {
    uuid = "3f74d2e3-5a67-4b86-b2c3-842f39e45b7a";
    keyfile = "/root/keys/ht02";
    mount = "/mnt/ht02";
    fs = "xfs";
  };

  ht03 = {
    uuid = "5a67d2e3-842f-3f74-b2c3-4b8639e45b7a";
    keyfile = "/root/keys/ht03";
    mount = "/mnt/ht03";
    fs = "ext4";
  };
};
```

#### What happens automatically

For each entry:

1. A `/etc/crypttab` entry is generated:

   ```
   <name> UUID=<uuid> <keyfile> luks,nofail
   ```
2. The device unlocks to `/dev/mapper/<name>`
3. A filesystem entry is created:

   ```
   fileSystems."<mount>" = {
     device = "/dev/mapper/<name>";
     fsType = "<fs>";
   };
   ```

### hdparm Configuration (device.hdparm)

Use `device.hdparm` to disable aggressive head-parking or alter disk power
behavior for HDDs.

This accepts a **list of disk IDs** (as used in `/dev/disk/by-id`).

#### Example

```nix
device.hdparm = [
  "usb-WD_Elements_25A2_575852314134393745303255-0:0"
  "usb-Seagate_Expansion_1234567890ABCDEF-0:0"
];
```

#### What the system generates

One systemd service per disk:

```
hdparm-0.service
hdparm-1.service
...
```

Each service runs:

```
hdparm -B 254 -S 0 /dev/disk/by-id/<id>
```

This prevents aggressive head parking and increases drive longevity.

### Summary

| Feature               | Config Location | Description                              |
| --------------------- | --------------- | ---------------------------------------- |
| **Unencrypted mount** | `device.mount`  | Direct filesystem mounts                 |
| **Encrypted (LUKS)**  | `device.luks`   | Creates crypttab entries + mapper mounts |
| **hdparm tuning**     | `device.hdparm` | Generates systemd services per drive     |

# Security & Privacy

Several security and privacy oriented decisions were made while writing the
included modules.

This section is a non-exhaustive list of such decisions.

## Encryption

LUKS encrypted external disks can be added easily. See
[Adding External Disks](#adding-external-disks).

## Kernel

The `linux-hardened` kernel is used.

Several [kernel parameters](../modules/common/boot/params.nix),
[sysctl options](../modules/common/boot/sysctl.nix) and
[module blacklists](../modules/common/boot/blacklist.nix) are put in place to
ensure better baseline security.

These options are heavily based on
[this](https://madaidans-insecurities.github.io/guides/linux-hardening.html)
article by Madaidan's Insecurities.

## Auditing

The Linux auditing subsystem is enabled and rules have been set, following some
reasonable STIGs.

The full list of rules can be found [here](../modules/common/audit/).

## Firewall

The NixOS firewall is used with all ports closed, and all interfaces untrusted
by default. This configuration can be found
[here](../modules/common/network/firewall.nix).

The firewall uses `iptables` (*`iptables-nft`) with the modern `nf_tables`
backend.

Ports are opened based on the running services.

The server firewall configuration can be found
[here](../modules/server/network/firewall.nix).

While most ports open internally to be used by the [nginx](#nginx) reverse
proxy, two ports are opened to `vars.network.range`:

1. `vars.network.ssh.port`: For SSH

2. `vars.network.i2pd.httpProxy.port`: For I2P HTTP Proxy

So, it is recommended to change these ports from the default.

Also, `vars.network.range` can be set in the variables file. To edit the
variables file:

```bash
nixos edit vars
```

Since this value is a CIDR, it can be used to allow specific IPs only. For
example, setting it to `192.168.0.98/31` allows for two IPs: `192.168.0.98` and
`192.168.0.99`.

## Nix Package Manager

The Nix package manager is set to download only cryptographically signed
binaries.

Furthermore, only members of the `wheel` group can use the Nix package manager.

## Passwords & Secrets

The Vaultwarden password manager is installed and can be used to store passwords
and other secrets securely.

See [Vaultwarden](#vaultwarden) for more details.

Secrets related to the NixOS system are stored securely by
[sops-nix](http://github.com/Mic92/sops-nix) using GPG keys.

To edit sops-nix secrets:

```bash
nixos edit sops
```

These secrets are available under `/run/secrets` after system activation and are
stored encrypted in the world-readable `/nix/store`.

These secrets are not tracked by git.

## DNS

The Unbound recursive DNS server is installed and can be used to make private
DNS queries with DNSSEC.

See [Unbound](#unbound) for more details.

The fallback DNS servers are Cloudflare's `1.1.1.1` and `1.0.0.1`.

## Search Engine

The SearXNG metasearch engine is installed and can be used to make private
search queries.

See [SearXNG](#searxng) for more details.

## SSH

The SSH daemon is installed and uses hardened settings.

See [SSH](#ssh) for more details.

## I2P

The i2pd router is installed and can be used to use the
[I2P](https://geti2p.net/en/) network.

See [I2PD](#i2pd) for more details.

The included bittorrent client, [qBittorrent](#qbittorrent), also uses the I2P
network.
