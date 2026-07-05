# Pi Usage

This document covers using the Pi role.

# Contents

1. [System Maintenance](#system-maintenance)
2. [Bind Mounts and External Disks](#bind-mounts-and-external-disks)
3. [Services](#services)
4. [Using Selfhosted Features](#using-selfhosted-features)
5. [Further Reading](#further-reading)

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

Only the SSH server is available.

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

# Using Selfhosted Features

The Pi can only use the Server for DNS.

Note that services are exposed using on Server using WireGuard. WireGuard is
configured in the variables file under `vars.wireguard`.

Example configuration for Pi (`10.20.0.2` on wireguard) with a single peer Pi
(`10.20.0.1` on wireguard, `10.0.0.3` on LAN):

```nix
{
  # wireguard vpn
  wireguard = {

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

1. Unbound DNS resolver

   Set the `vars.wireless.resolver` to the Server WireGuard peer address.

# Further Reading

- [Security Features](../security.md)
- [Filesystem and Impermanence Documentation](../filesystems.md)
- [CLI Documentation](../cli.md)
