# Server Usage

This document covers using the Server role.

# Contents

1. [System Maintenance](#system-maintenance)
2. [Bind Mounts and External Disks](#bind-mounts-and-external-disks)
3. [Services](#services)
4. [Further Reading](#further-reading)

# System Maintenance

## Routine Tasks

Routine tasks such as updating the flake, switching configurations,
garbage-collecting, and editing variables & secrets are handled through the
bespoke unified `nixos(1)` wrapper CLI.

Manpage:

```bash
man nixos
```

See [CLI Documentation](../cli.md) for the full command reference and workflow
examples.

## Variables and Secrets

The flake uses variables for device-specific configuration.

For example, server services can be configured and external drives can be
mounted via the variables file. To edit the variables file:

```bash
nixos edit vars
```

The flake uses secrets (via `sops`) for sensitive information.

For example, the hashed user password, the network PSK, the DuckDNS API key,
etc. are configured via `sops`. To edit the sops file:

```bash
nixos edit sops
```

# Bind Mounts and External Disks

Bind mounts and external disks can be used to put files in expected data
directories.

See
[Filesystem and Impermanence Documentation](../filesystems.md#additional-disks-and-mounts)
for more information.

# Services

The following services are available:

- SSH Server
- Unbound
- NGINX
- SearXNG
- Vaultwarden
- I2PD
- qBittorrent
- Jellyfin

## SSH Server

OpenSSH secure shell daemon with a hardened configuration. SSH is also required
for [seeding](../cli.md#build-remote-closures) the current machine.

### Enabling

Enabled using `vars.services.ssh.enable`.

### Ports

Open on LAN to the private CIDR defined by `vars.services.ssh.allow`:

1. `vars.services.ssh.port`

### Keys

Trusted public keys are defined in `vars.services.ssh.trusted-keys`.

Host keys are generated and stored under `/etc/ssh`.

### Example Variables Configuration

For `vars.services.ssh`

```nix
{
  enable = true;
  allow = "10.0.0.4/31"; # allow 10.0.0.4 and 10.0.0.5
  trusted-keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4BfT6bp+fl83TyrSFAerXpAq6AVmVlfUnfnPU3jHHY example@example"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+iL2MFXNyxd3Hu6akfdOBeI6HYWE4R0LTBScTHCoyH example@example"
  ];
}
```

## Unbound

Unbound recursive validating DNS server with a hardened configuration.

### Enabling

Enabled using `vars.services.unbound.enable`

### Ports

Open on loopback to `127.0.0.1`:

1. `53/tcp` dns
2. `53/udp` dns

Open on LAN to the private CIDR defined by `vars.services.unbound.allow`:

1. `53/tcp` dns
2. `53/udp` dns

### Extra Entries

Additional entries can be added using `vars.services.unbound.local-data`.

### Data

Data is stored under `/var/lib/unbound`.

## NGINX

Web server and reverse proxy.

### Enabling

Enabled using `vars.services.nginx.enable`.

### Ports

Open on LAN to private CIDR defined by `vars.services.nginx.allow`:

1. `443` https

### Domain

The nginx web server is hosted at `https://<your-duckdns-domain>`.

The DuckDNS domain is declared using `vars.services.nginx.domain`.

It attempts to fetch a Let's Encrypt HTTPS certificate with a DNS-01 challenge
using your duckdns domain.

Certificates are renewed using ACME, which stores them in `/var/lib/acme`.

### Reverse Proxy

The root of the web server returns a
[homepage](https://github.com/sotormd/homepage) with links to all the services'
reverse proxy pages.

Reverse proxy is set up for the following services, if enabled:

| Location        | Name                  | Description                 | Allowed private CIDR              |
| --------------- | --------------------- | --------------------------- | --------------------------------- |
| `/searxng/`     | SearXNG               | Search engine               | `vars.services.searxng.allow`     |
| `/vaultwarden/` | Vaultwarden web vault | Password manager            | `vars.services.vaultwarden.allow` |
| `/i2pd/`        | I2PD web console      | Invisible Internet Protocol | `vars.services.i2pd.allow`        |
| `/qbt/`         | qBittorrent webui     | Bittorrent client           | `vars.services.qbt.allow`         |
| `/jellyfin/`    | Jellyfin              | Media server                | `vars.services.jellyfin.allow`    |

## SearXNG

Fast, private metasearch engine.

### Enabling

Enabled using `vars.services.searxng.enable`.

### Ports

Open on loopback to `127.0.0.1`:

1. `8888` search engine

### Search Engines

The following search engines are enabled by default on the general tab:

1. Bing
2. DuckDuckGo
3. Google
4. Startpage
5. Wikipedia

### Key

Requires a secret key which is stored using sops-nix.

## Vaultwarden

Password manager.

### Enabling

Enabled using `vars.services.vaultwarden.enable`.

### Ports

Open on loopback to `127.0.0.1`:

1. `8222` web vault

### Vault

The vault is stored at `/var/lib/bitwarden_rs`.

## I2PD

Router for the I2P network.

### Enabling

Enabled using `vars.services.i2pd.enable`.

### Ports

Open on loopback to `127.0.0.1`:

1. `7656` SAM
2. `4447` SOCKS proxy
3. `7070` webconsole

Open on LAN to the private CIDR defined by `vars.services.i2pd.allow`:

1. `4444` HTTP proxy

### Data

Data is stored under `/var/lib/i2pd`.

## qBittorrent

Web interface for the qBittorrent bittorrent client.

### Enabling

Enabled using `vars.services.qbt.enable`.

### Ports

Open on loopback to `127.0.0.1`:

1. `8080` webui

### Data

Data is stored under `/var/lib/qbt`.

### Torrents

Default torrent download directory is `/srv/torrents/downloads`.

Additionally, two categories are created: Movies and TV.

Default download directory for Movies is: `/srv/torrents/movies`.

Default download directory for TV is: `/srv/torrents/tv`.

### Initial Setup

qBittorrent will initially start with username `admin` and a random password.
Check the service status for the password.

```bash
systemctl status qbt
```

Then, in the web ui `https://<your-duckdns-domain>/qbt/` under
`Tools > Options > WebUI > Authentication` set a username and password.

## Jellyfin

Media server.

### Enabling

Enabled using `vars.services.jellyfin.enable`.

### Ports

Open on loopback to `127.0.0.1`:

1. `8096` web interface

### Data

Data is stored under `/var/lib/jellyfin`.

### Initial Setup

Access the web interface at `https://<your-duckdns-domain>/jellyfin/` and follow
the wizard to set up your user and library.

To use torrents from qBittorrent, add `/srv/torrents/movies` and
`/srv/torrents/tv`.

### Disabling media playback

If using only the `Download` and/or `Copy Stream URL` options, you can disable
media playback by disallowing it for your user.

1. Access the web interface at `https://<your-duckdns-domain>/jellyfin/`

2. Uncheck `Allow media playback` under
   `Dashboard > Users > <your-user> > Profile > Media Playback`.

3. Click `Save` at the end of the page.

# Further Reading

- [Security Features](../security.md)
- [Filesystem and Impermanence Documentation](../filesystems.md)
- [CLI Documentation](../cli.md)
