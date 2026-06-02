# Server Usage

This document covers using the Server role.

# Contents

1. [System Maintenance](#system-maintenance)
2. [Bind Mounts and External Disks](#bind-mounts-and-external-disks)
3. [Services](#services)
4. [MicroVMs](#microvms)
5. [WireGuard](#wireguard)
6. [Further Reading](#further-reading)

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

The variables file can be used to create bind mounts, which can be used to put
files in expected data directories from external disks.

See [Additional Disks and Mounts](../filesystems.md#additional-disks-and-mounts)
for more information.

# Services

The following services are available:

- [SSH Server](#ssh-server)
- [Unbound](#unbound)
- [NGINX](#nginx)
- [SearXNG](#searxng)
- [Vaultwarden](#vaultwarden)
- [I2PD](#i2pd)
- [qBittorrent](#qbittorrent)

## SSH Server

OpenSSH secure shell daemon with a hardened configuration. SSH is also required
for [seeding](../cli.md#build-remote-closures) the current machine.

OpenSSH runs on the Host.

### Enabling

Enabled using `vars.services.ssh.enable`.

### Ports

Open on LAN to the private CIDR defined by `vars.services.ssh.allow`:

1. `vars.services.ssh.port`

### Keys

Trusted public keys are defined in `vars.services.ssh.trusted-keys`.

Host keys are generated and stored under `/etc/ssh`.

### Access Control

Access control is enforced in the following places:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.services.ssh.allow`, for nftables
  filtering on LAN
- public key in `vars.services.ssh.trusted-keys`, for OpenSSH authorization

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

Unbound runs in a MicroVM. See [MicroVMs](#microvms) for more information.

### Enabling

Enabled using `vars.services.unbound.enable`

### Ports

Open on WireGuard to the private CIDR defined by `vars.services.unbound.allow`:

1. `53/tcp` dns
2. `53/udp` dns

### Extra Entries

Additional entries can be added using `vars.services.unbound.local-data`.

### Data

Data is stored under `/var/lib/unbound`.

### Access Control

Access control is enforced in the following places:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.unbound.allow`, for
  nftables filtering on WireGuard
- in the private WireGuard CIDR defined by `vars.services.unbound.allow`, for
  Unbound's access control

## NGINX

Web server and reverse proxy.

NGINX runs in a MicroVM. See [MicroVMs](#microvms) for more information.

### Enabling

Enabled using `vars.services.nginx.enable`.

### Ports

Open on WireGuard to private CIDR defined by `vars.services.nginx.allow`:

1. `443` https

### Domain

The nginx web server is hosted at `https://<your-duckdns-domain>`.

The DuckDNS domain is declared using `vars.services.nginx.domain`.

It attempts to fetch a Let's Encrypt HTTPS certificate with a DNS-01 challenge
using your duckdns domain.

Certificates are renewed using ACME, which stores them in `/var/lib/acme`.

### Locations

The root of the web server returns a
[homepage](https://github.com/sotormd/homepage) with links to all the enabled
services' reverse proxy pages. There are additional locations as well. All
possible locations are listed below:

| Location        | Name                  | Description                 | Allowed private CIDR              |
| --------------- | --------------------- | --------------------------- | --------------------------------- |
| `/searxng/`     | SearXNG               | Search engine               | `vars.services.searxng.allow`     |
| `/vaultwarden/` | Vaultwarden web vault | Password manager            | `vars.services.vaultwarden.allow` |
| `/i2pd/`        | I2PD web console      | Invisible Internet Protocol | `vars.services.i2pd.allow`        |
| `/qbt/`         | qBittorrent webui     | Bittorrent client           | `vars.services.qbt.allow`         |
| `/torrents/`    | qBittorrent torrents  | Torrents in `/srv/torrents` | `vars.services.qbt.allow`         |
| `/static/`      | Static serve          | `/srv/static`               | -                                 |

Note that NGINX itself is open to `vars.services.nginx.allow` only.

### Access Control

Access control is enforced in the following places:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.nginx.allow`, for
  nftables filtering on WireGuard
- in the private WireGuard CIDR defined by `vars.services.<name>.allow` for
  specific [locations](#locations), for NGINX allow rules

## SearXNG

Fast, private metasearch engine.

### Enabling

Enabled using `vars.services.searxng.enable`.

SearXNG runs in a MicroVM. See [MicroVMs](#microvms) for more information.

### Search Engines

The following search engines are enabled by default on the general tab:

1. Bing
2. DuckDuckGo
3. Google
4. Startpage
5. Wikipedia

### Key

Requires a secret key which is stored using sops-nix.

### Access Control

Access control is enforced in the following places:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.nginx.allow`, for
  nftables filtering on WireGuard
- in the private WireGuard CIDR defined by `vars.services.searxng.allow`, for
  NGINX allow rules

## Vaultwarden

Password manager.

### Enabling

Enabled using `vars.services.vaultwarden.enable`.

Vaultwarden runs in a MicroVM. See [MicroVMs](#microvms) for more information.

### Vault

The vault is stored at `/var/lib/bitwarden_rs`.

### Access Control

Access control is enforced in the following places:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.nginx.allow`, for
  nftables filtering on WireGuard
- in the private WireGuard CIDR defined by `vars.services.vaultwarden.allow`,
  for NGINX allow rules

## I2PD

Router for the I2P network.

### Enabling

Enabled using `vars.services.i2pd.enable`.

I2PD runs in a MicroVM. See [MicroVMs](#microvms) for more information.

### Ports

Open on WireGuard to the private CIDR defined by `vars.services.i2pd.allow`:

1. `4444` HTTP proxy

### Data

Data is stored under `/var/lib/i2pd`.

### Access Control

Access control is enforced in the following places:

For webconsole:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.nginx.allow`, for
  nftables filtering on WireGuard
- in the private WireGuard CIDR defined by `vars.services.i2pd.allow`, for NGINX
  allow rules

For HTTP proxy:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.i2pd.allow`, for
  nftables filtering on WireGuard

## qBittorrent

Web interface for the qBittorrent bittorrent client.

qBittorrent runs in a MicroVM. See [MicroVMs](#microvms) for more information.

### Enabling

Enabled using `vars.services.qbt.enable`.

### Data

Data is stored under `/var/lib/qbt`.

### Torrents

Default torrent download directory is `/srv/torrents/downloads`.

Additionally, two categories are created: Movies and TV.

Default download directory for Movies is: `/srv/torrents/movies`.

Default download directory for TV is: `/srv/torrents/tv`.

The entirety of `/srv/torrents` can be viewed at the NGINX location
`/torrents/`.

### Initial Setup

qBittorrent will initially start with username `admin` and a random password.
Check the service status for the password. Since qBittorrent runs in a MicroVM,
ssh into the MicroVM first.

```bash
microvm -s qbt
systemctl status qbt
```

Then, in the web ui `https://<your-duckdns-domain>/qbt/` under
`Tools > Options > WebUI > Authentication` set a username and password.

### Access Control

Access control is enforced in the following places:

Clients must satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.nginx.allow`, for
  nftables filtering on WireGuard
- in the private WireGuard CIDR defined by `vars.services.qbt.allow`, for NGINX
  allow rules

# MicroVMs

Several services run in MicroVMs. Each MicroVM uses its own interface and runs
behind a NAT. Rather than being bridged, the VMs use a
[routed network model](https://microvm-nix.github.io/microvm.nix/routed-network.html).
The nftables firewall is used to allow restricted access to required regions.
See [Firewall](../security.md#firewall) for more information.

| MicroVM       | (internal) IP Address | Interface | Gateway      |
| ------------- | --------------------- | --------- | ------------ |
| `unbound`     | `10.204.3.2`          | `svcvm3`  | `10.204.3.1` |
| `nginx`       | `10.204.4.2`          | `svcvm4`  | `10.204.4.1` |
| `searxng`     | `10.204.5.2`          | `svcvm5`  | `10.204.5.1` |
| `vaultwarden` | `10.204.6.2`          | `svcvm6`  | `10.204.6.1` |
| `i2pd`        | `10.204.7.2`          | `svcvm7`  | `10.204.7.1` |
| `qbt`         | `10.204.8.2`          | `svcvm8`  | `10.204.8.1` |

Each MicroVM can be manually started/stopped/restarted using `systemctl`. For
example:

```bash
systemctl start microvm@unbound
systemctl stop microvm@qbt
systemctl restart microvm@searxng
```

It is possible to SSH into the MicroVMs using VSOCK from the host with the root
password `toor` if the corresponding `vars.services.<name>.debug` is set to
`true`. For example, if `vars.services.nginx.debug` is set to `true`:

```bash
microvm -s nginx
```

# WireGuard

Services are exposed using WireGuard over LAN. WireGuard is configured in the
variables file under `vars.wireguard`.

Example configuration for Server (`10.20.0.1` on wireguard) with a single peer
Laptop (`10.20.0.2` on wireguard, `10.0.0.2` on LAN):

```nix
{
  # wireguard vpn
  wireguard = {

    # wireguard address
    address = "10.20.0.1";

    # wireguard port
    port = 51820;

    # wireguard peers
    peers = [
      {
        PublicKey = "F3625gAtaFYmIl8Od3DaR+FWZYukzlkHNHZCuNAR0A4=";
        AllowedIPs = "10.20.0.2/32";
        PersistentKeepalive = 25;
      }
    ];

    # private CIDR (LAN) to allow
    # used by nftables only
    allow = "10.0.0.2/32";

  };
}
```

Multiple peers can be added like this. The individual
`vars.services.<name>.allow` CIDRs can then be set to WireGuard peer CIDRs.

The Server has to be declared as a peer on the Laptop as well.

# Further Reading

- [Security Features](../security.md)
- [Filesystem and Impermanence Documentation](../filesystems.md)
- [CLI Documentation](../cli.md)
