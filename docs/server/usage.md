# Usage

This document covers using the `server` role.

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
garbage-collecting, repairing the Nix store, and editing variables & secrets are
handled through the unified `nixos(1)` helper CLI.

Manpage:

```bash
man nixos
```

Overview:

```bash
nixos help
```

See [scripts.md](../scripts.md) for the full command reference and workflow
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

OpenSSH secure shell daemon.

Enabled by default.

Exposes one port to `vars.network.range`: `vars.network.ssh.port`.

Trusted public keys are defined in `vars.network.ssh.keys`.

SSH uses a hardened configuration which can be found
[here](../../modules/server/ssh/settings.nix).

# Unbound

Unbound is a recursive validating DNS server.

Enabled using `vars.network.unbound.`

Exposes two ports to `vars.network.range`: `53/tcp` `53/udp`.

Unbound uses a hardened configuration which can be found
[here](../../modules/server/unbound/settings.nix).

# NGINX

Nginx is a web server and reverse proxy.

Enabled using `vars.network.nginx.enable`.

Exposes one port to `vars.network.range`: `443`.

## Domain

The nginx web server is hosted at `https://<your-duckdns-domain>`.

The DuckDNS domain is declared using `vars.network.duckdns.domain`.

It attempts to fetch a Let's Encrypt HTTPS certificate with a DNS-01 challenge
using your duckdns domain.

## Reverse Proxy

The root of the web server returns a
[homepage](https://github.com/sotormd/homepage) with links to all the services'
reverse proxy pages.

Reverse proxy is set up for the following services, if enabled:

| Location       | Name                  | Description                 |
| -------------- | --------------------- | --------------------------- |
| `/searxng`     | SearXNG               | Search engine               |
| `/vaultwarden` | Vaultwarden web vault | Password manager            |
| `/i2pd`        | I2PD web console      | Invisible Internet Protocol |
| `/qbt`         | qBittorrent webui     | Bittorrent client           |
| `/jellyfin`    | Jellyfin              | Media server                |

# SearXNG

SearXNG is a fast, private metasearch engine.

Enabled using `vars.network.searxng.enable`.

Doesn't expose any ports since it uses `uwsgi`.

The full list of enabled search engines can be found
[here](../../modules/server/searxng/engines.nix).

# Vaultwarden

Vaultwarden is a password manager.

Enabled using `vars.network.vaultwarden.enable`.

Exposes one port to the loopback interface: `vars.network.vaultwarden.port`.

Data directory is declared by `vars.network.vaultwarden.data`.

# I2PD

I2PD is a router for the I2P network.

Enabled using `vars.network.i2pd.enable`.

Exposes three ports to the loopback interface:
`vars.network.i2pd.webconsole.port` `vars.network.i2pd.socksProxy.port`
`vars.network.i2pd.sam.port`.

Exposes one port to `vars.network.range`: `vars.network.i2pd.httpProxy.port`.

# qBittorrent

qBittorrent-nox is a web interface for the qBittorrent bittorrent client.

Enabled using `vars.network.qbt.enable`.

Exposes one port to the loopback interface: `vars.network.qbt.port`.

Data directory is declared by `vars.network.qbt.data`.

## Initial Setup

qBittorrent will initially start with username `admin` and a random password.
Check the service status for the password.

```bash
systemctl status qbt
```

Then, in the web ui `https://<your-duckdns-domain>/qbt` under
`Tools > Options > WebUI > Authentication` set a username and password.

## Categories

Two categories, `Movies` and `TV`, are created by default.

# Jellyfin

Jellyfin is a media server.

Enabled using `vars.network.jellyfin.enable`.

Exposes one port to the loopback interface: `vars.network.jellyfin.port`.

Data directory is declared by `vars.network.jellyfin.data`.

## Initial Setup

Access the web interface at `https://<your-duckdns-domain>/jellyfin` and follow
the wizard to set up your user and library.

## Disabling media playback

If using only the `Download` and/or `Copy Stream URL` options, you can disable
media playback by disallowing it for your user.

1. Access the web interface at `https://<your-duckdns-domain>/jellyfin`

2. Uncheck `Allow media playback` under
   `Dashboard > Users > <your-user> > Profile > Media Playback`.

3. Click `Save` at the end of the page.
