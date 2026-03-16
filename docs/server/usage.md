# Server Usage

This document covers using the Server role.

# Contents

1. [System Maintenance](#system-maintenance)
2. [SSH](#ssh)
3. [Unbound](#unbound)
4. [NGINX](#nginx)
5. [SearXNG](#searxng)
6. [Vaultwarden](#vaultwarden)
7. [I2PD](#i2pd)
8. [qBittorrent](#qbittorrent)
9. [Jellyfin](#jellyfin)

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

# SSH

OpenSSH secure shell daemon with a hardened configuration.

## Enabling

Enabled by default.

## Ports

Open on `vars.network.address` to `vars.network.range`:

1. `vars.network.ssh.port`

## Keys

Trusted public keys are defined in `vars.network.ssh.keys`.

# Unbound

Unbound recursive validating DNS server with a hardened configuration.

## Enabling

Enabled using `vars.services.unbound.enable`

## Ports

Open on `127.0.0.1`:

1. `53/tcp` dns
2. `53/udp` dns

Open on `vars.network.address` to `vars.network.range`

1. `53/tcp` dns
2. `53/udp` dns

## Data

Data is stored under `/var/lib/unbound`.

# NGINX

Web server and reverse proxy.

## Enabling

Enabled using `vars.services.nginx.enable`.

## Ports

Open on `vars.network.address` to `vars.network.range`:

1. `443` https

## Domain

The nginx web server is hosted at `https://<your-duckdns-domain>`.

The DuckDNS domain is declared using `vars.network.domain`.

It attempts to fetch a Let's Encrypt HTTPS certificate with a DNS-01 challenge
using your duckdns domain.

Certificates are renewed using ACME, which stores them in `/var/lib/acme`.

## Reverse Proxy

The root of the web server returns a
[homepage](https://github.com/sotormd/homepage) with links to all the services'
reverse proxy pages.

Reverse proxy is set up for the following services, if enabled:

| Location        | Name                  | Description                 |
| --------------- | --------------------- | --------------------------- |
| `/searxng/`     | SearXNG               | Search engine               |
| `/vaultwarden/` | Vaultwarden web vault | Password manager            |
| `/i2pd/`        | I2PD web console      | Invisible Internet Protocol |
| `/qbt/`         | qBittorrent webui     | Bittorrent client           |
| `/jellyfin/`    | Jellyfin              | Media server                |

## Static

The `/static/` location points to files in `/srv/static` which can be used to
serve static files.

## Ad-Hoc Reverse Proxy

The `/adhoc/*` locations can be used to reverse proxy services in an ad-hoc
manner.

Only ports from `10000` to `10999` are allowed. For example, `/adhoc/10111/`
proxies to `http://127.0.0.1:10111`. Note that these ports are still blocked by
the firewall (even on loopback) so the `nixos-firewall-tool` needs to be used to
open them on a ad-hoc basis so that nginx can access them through the loopback
interface.

# SearXNG

Fast, private metasearch engine.

## Enabling

Enabled using `vars.services.searxng.enable`.

## Ports

Doesn't open any ports since it uses `uwsgi`.

## Search Engines

The following search engines are enabled by default on the general tab:

1. Bing
2. DuckDuckGo
3. Google
4. Startpage
5. Yahoo
6. Wikipedia

## Key

Requires a secret key which is stored using sops-nix.

# Vaultwarden

Password manager.

## Enabling

Enabled using `vars.services.vaultwarden.enable`.

## Ports

Open on `127.0.0.1`:

1. `8222` web vault

## Vault

The vault is stored at `/var/lib/bitwarden_rs`.

# I2PD

Router for the I2P network.

## Enabling

Enabled using `vars.services.i2pd.enable`.

## Ports

Open on `127.0.0.1`:

1. `7656` SAM
2. `4447` SOCKS proxy
3. `7070` webconsole
4. `9999` nginx server for eepsite

Open on `vars.network.address` to `vars.network.range`:

1. `4444` HTTP proxy

## Data

Data is stored under `/var/lib/i2pd`.

Root for the eepsite is at `/srv/i2p`.

# qBittorrent

Web interface for the qBittorrent bittorrent client.

## Enabling

Enabled using `vars.services.qbt.enable`.

## Ports

Open on `127.0.0.1`:

1. `8080` webui

## Data

Data is stored under `/var/lib/qbt`.

## Torrents

Default torrent download directory is `/srv/torrents/downloads`.

Additionally, two categories are created: Movies and TV.

Default download directory for Movies is: `/srv/torrents/movies`.

Default download directory for TV is: `/srv/torrents/tv`.

## Initial Setup

qBittorrent will initially start with username `admin` and a random password.
Check the service status for the password.

```bash
systemctl status qbt
```

Then, in the web ui `https://<your-duckdns-domain>/qbt/` under
`Tools > Options > WebUI > Authentication` set a username and password.

# Jellyfin

Media server.

## Enabling

Enabled using `vars.services.jellyfin.enable`.

## Ports

Open on `127.0.0.1`:

1. `8096` web interface

## Data

Data is stored under `/var/lib/jellyfin`.

## Initial Setup

Access the web interface at `https://<your-duckdns-domain>/jellyfin/` and follow
the wizard to set up your user and library.

To use torrents from qBittorrent, add `/srv/torrents/movies` and
`/srv/torrents/tv`.

## Disabling media playback

If using only the `Download` and/or `Copy Stream URL` options, you can disable
media playback by disallowing it for your user.

1. Access the web interface at `https://<your-duckdns-domain>/jellyfin/`

2. Uncheck `Allow media playback` under
   `Dashboard > Users > <your-user> > Profile > Media Playback`.

3. Click `Save` at the end of the page.
