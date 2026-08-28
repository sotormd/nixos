# Pi Usage

This document covers using the Pi role.

# Contents

1. [System Maintenance](#system-maintenance)
2. [Bind Mounts and External Disks](#bind-mounts-and-external-disks)
3. [Services](#services)
4. [Networking](#networking)
5. [Using Selfhosted Features](#using-selfhosted-features)
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

The flake uses secrets via SOPS) for sensitive information.

For example, the hashed user password, the network PSK, the DuckDNS API key,
etc. are configured via SOPS. To edit the SOPS file:

```bash
nixos edit sops
```

# Bind Mounts and External Disks

The variables file can be used to create bind mounts, which can be used to put
files in expected data directories from external disks.

See [Additional Disks and Mounts](../filesystems.md#additional-disks-and-mounts)
for more information.

# Services

1. [dnscrypt-proxy](#dnscrypt-proxy)
2. [SSH Server](#ssh-server)

## dnscrypt-proxy

DNS server for DoH (with Cloudflare 1.0.0.2, malware blocking) and an additional
[StevenBlack](https://github.com/stevenblack/hosts) blocklist.

### Enabling

Enabled using `vars.services.dnscrypt.enable`.

### Ports

Open on loopback `127.0.0.1`:

1. `53/tcp` dns
2. `53/udp` dns

These ports are also opened on:

1. Hostapd gateway `vars.network.hostapd.address`, if hostapd is enabled.

## SSH Server

OpenSSH secure shell daemon with a hardened configuration. SSH is also required
for [seeding](../cli.md#build-remote-closures) the current machine.

### Enabling

Enabled using `vars.services.ssh.enable`.

### Ports

Open on wireless or hostapd LAN to the private CIDR defined by
`vars.services.ssh.allow`:

1. `vars.services.ssh.port`

If both wireless and hostapd are disabled, then it is opened on all interfaces
(`0.0.0.0`).

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

# Networking

Networking is configured using `vars.network`.

1. [Wireless](#wireless)
2. [WireGuard](#wireguard)
3. [Hostapd](#hostapd)
4. [Wired](#wired)

## Wireless

Wireless networking is configured using `vars.network.wireless` and is enabled
using `vars.network.wireless.enable`.

Static addresses are used instead of DHCP. This is configured using
`vars.network.wireless.{gateway,address}`.

The SSID is configured using `vars.network.wireless.ssid` and the password is
stored using SOPS.

```nix
{
  # wpa_supplicant wireless networking
  wireless = {

    # enable wireless networking
    enable = true;

    # wireless NIC identifier
    interface = "wlp1s0";

    # wireless network ssid
    # password is stored using sops-nix
    ssid = "example";

    # wireless network authentication protocols
    authentication = [ "SAE" ];

    # wireless network gateway
    gateway = "10.0.0.1";

    # static IP address
    address = "10.0.0.2";

  };
}
```

## WireGuard

See [Using Selfhosted Features](#using-selfhosted-features) for information
about using WireGuard.

## Hostapd

Hostapd can be used to create a wireless access point (AP) that other devices
can connect to. Hostapd is configured using `vars.network.hostapd`. The password
is stored using SOPS.

```nix
{
  # hostapd AP and authentication server
  hostapd = {

    # enable hostapd
    enable = true;

    # hostapd wireless NIC identifier
    # hostapd and wireless can't use the same interface
    interface = "wlan0";

    # uplink interface
    # provides connectivity
    uplink = "eth0";

    # regulatory domain
    # as a country code
    domain = "IN";

    # ssid name
    # password is stored using sops-nix
    ssid = "example-lan";

    # authentication protocol
    authentication = "wpa3-sae";

    # address for gateway
    # prefix 24 will be used
    address = "192.168.0.1";

  };
}
```

## Wired

Wired networking can be used using `vars.network.wired`, this uses DHCP.

```nix
{
  # optional wired networking
  # with DHCP
  wired = {

    # enable wired networking
    enable = true;

    # wired NIC identifier
    interface = "eth0";

  };
}
```

# Using Selfhosted Features

Services are exposed by Server using WireGuard. WireGuard is configured in the
variables file under `vars.network.wireguard`.

Pi can use selfhosted services from Server using WireGuard (configured using
`vars.network.wireguard`).

Example configuration for Pi (`10.20.0.2` on wireguard) with a single peer
Server (`10.20.0.1` on wireguard, `10.0.0.3` on LAN):

```nix
{
  # wireguard vpn
  wireguard = {

    # enable wireguard
    enable = true;

    # wireguard address
    address = "10.20.0.2";

    # wireguard port
    port = 51820;

    # wireguard peers
    peers = [
      {
        PublicKey = "dfk4SUxCbQQcR18XAkh3bGyrvOBd+nscYCZWiFUrkGA=";
        Endpoint = "10.0.0.3:51820";
        AllowedIPs = [ "10.20.0.1/32" ];
        PersistentKeepalive = 25;
      }
    ];

  };
}
```

The Pi has to be declared as a peer on the Server as well. See
[Server Usage Documentation](../server/usage.md#wireguard).

1. NGINX reverse proxy endpoints

   All the locations can be accessed, see
   [Server Usage Documentation](../server/usage.md#locations) for a full list.

2. I2PD i2p router

   The HTTP proxy can be independently used with no further configuration.

# Further Reading

- [Security Features](../security.md)
- [Filesystem and Impermanence Documentation](../filesystems.md)
- [CLI Documentation](../cli.md)
