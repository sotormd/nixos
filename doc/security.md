# Security Features Summary

This document attempts to cover the various security features for Workstation,
Server and Pi roles.

This is a larger document than other documents in this flake. It is possible
that errors may be present in this document. In any case, the flake source
should be referred to as the primary and only source of truth.

# Threat Model

Security without a threat model is meaningless. The threat model for this flake
is general desktop / home usage with a semi-untrusted LAN, and NOT anything
requiring specialized security, advanced privacy or defence against
sophisticated targeted attacks. Consider [Qubes](https://www.qubes-os.org/) for
decent security against these attacks, backed by the guarantees of the
[Xen project hypervisor](https://xenproject.org/).

The targets covered in this document are:

- Workstation, my workstation configuration for generic personal computers
- Server, my home-server configuration for hosts that serve Virtual Machine
  services on WireGuard over wireless LAN.
- Pi, my Raspberry Pi 4bs.

Unless explicitly mentioned, everything applies to all roles.

# Resources

- [Madaidan's Insecurities](https://madaidans-insecurities.github.io/guides/linux-hardening.html)
- [System Hardening Checklist - Kicksecure](https://www.kicksecure.com/wiki/System_Hardening_Checklist)
- [Kernel Hardening - Tails](https://tails.net/contribute/design/kernel_hardening/)
- [Security - ArchWiki](https://wiki.archlinux.org/title/Security)
- [Features - secureblue](https://secureblue.dev/features)
- [Paranoid NixOS - Xe Iaso](https://xeiaso.net/blog/paranoid-nixos-2021-07-18/)

# Known Issues

Warnings:

- Several hardening options may hinder performance or break certain workflows.
  This configuration caters to my specific setup **only**.
- Note that this document contains some options which aren't hardening or
  security related and are more of privacy / personal preference. Such options
  are noted.
- Note that this document contains some options which, at the time of writing,
  may be no-ops on NixOS. Such options are noted.

Missing features:

- AppArmor/SELinux support is not great under NixOS.
- LKRG (Linux Kernel Runtime Guard) does not work under NixOS.
- LOCKDOWN_LSM and MODULE_SIG are disabled in the kernel
  [upstream](https://github.com/NixOS/nixpkgs/blob/baeac6edff1b03f0ecd063b8fe48e9742d0527e7/pkgs/os-specific/linux/kernel/common-config.nix#L830)
  to ensure reproducibility.
- Hardened kernel has been dropped from Nixpkgs since it is no longer
  maintained.

# Contents

1. [Secure Boot](#secure-boot)
2. [Memory Allocator](#memory-allocator)
3. [Filesystems](#filesystems)
4. [Impermanence](#impermanence)
5. [Audit Subsystem](#audit-subsystem)
6. [Systemd Services](#systemd-services)
7. [Users and Privileges](#users-and-privileges)
8. [Nix Package Manager](#nix-package-manager)
9. [SOPS](#sops)
10. [Encryption and Signing](#encryption-and-signing)
11. [USBGuard](#usbguard)
12. [Wireless Networking](#wireless-networking)
13. [DNS](#dns)
14. [WireGuard](#wireguard)
15. [Firewall](#firewall)
16. [Virtualisation](#virtualisation)
17. [MAC Randomization](#mac-randomization)
18. [Secure Shell](#secure-shell)
19. [NGINX](#nginx)
20. [I2P and Anonymity](#i2p-and-anonymity)
21. [Display Server](#display-server)
22. [Desktop](#desktop)
23. [Session Locking](#session-locking)
24. [Bubblewrap](#bubblewrap)
25. [xdg-dbus-proxy](#xdg-dbus-proxy)
26. [Browsers](#browsers)
27. [Search Engine](#search-engine)
28. [Password Manager](#password-manager)
29. [Kernel Parameters](#kernel-parameters)
30. [sysctl Options](#sysctl-options)
31. [Module Blacklists](#module-blacklists)

# Secure Boot

> Workstation, Server only

Secure Boot is used to ensure that the bootloader is signed before loading.
Secure Boot support for NixOS is provided by the
[lanzaboote](https://github.com/nix-community/lanzaboote) project.

# Memory Allocator

The [`graphene-hardened`](https://github.com/GrapheneOS/hardened_malloc) malloc
from GrapheneOS is used. This provides substantial hardening against various
vulnerabilities.

# Filesystems

1. Mount Profiles

   Filesystem mounts are hardened using
   [Mount Profiles](./filesystems.md#mount-profiles). These are used to set the
   following options on sensitive mounts:

   ```
   nosuid
   nodev
   noexec
   ro
   ```

   See [Filesystem and Impermanence Documentation](./filesystems.md) for more
   information, including full lists of hardened mounts with/without
   Impermanence.

2. ZFS

   ZFS, which provides advanced self-healing capabilities and administration, is
   supported out-of-the-box.

   It is the also root filesystem on Workstation and Server.

3. Encrypted Mounts

   LUKS encrypted mounts can be added using the variables file. See
   [Additional Disks and Mounts](./filesystems.md#additional-disks-and-mounts)
   for more information.

4. Filesystem hardening sysctls

   Several `fs.*` sysctls are set. See [sysctl Options](#sysctl-options).

> Workstation, Server only

LUKS encryption with a passphrase is enabled for the root partition, containing
the main ZFS rpool. It is also possible to use TPM unlocking.

Random encryption is used on the swap partition.

# Impermanence

Impermanence ensures a clean filesystem after every reboot. Only explicitly
declared state survives across reboots, and anything else is purged. This
greatly reduces the persistent attack surface.

Impermanence is implemented differently on Workstation, Server and Pi, without
using the [library](https://github.com/nix-community/impermanence), using either
ZFS Snapshots or tmpfs for rollbacks and bind mounts for state persistence.

See [Impermanence](./filesystems.md#impermanence) for more information.

# Audit Subsystem

The Linux audit subsystem is enabled with the following rules:

- Log everytime a program is attempted to run

  ```
  -a exit,always -S execve -k rules-run
  ```

# Systemd Services

1. Service hardening

   Upstream Nixpkgs already hardens several common service, especially
   network-facing ones. Some services are additionally hardened with
   low-breakage service options. For example. `qbt.service` is hardened with
   these options:

   ```nix
   {
     ProtectClock = true;
     ProtectKernelTunables = true;
     ProtectKernelModules = true;
     ProtectKernelLogs = true;
     ProtectControlGroups = true;
     ProtectHome = true;
     ProtectHostname = true;
     SystemCallArchitectures = "native";
     LockPersonality = true;
     NoNewPrivileges = true;
     PrivateDevices = true;
     PrivateTmp = true;
     RestrictRealtime = true;
     RestrictSUIDSGID = true;
     RemoveIPC = true;
     PrivateUsers = true;
     ProtectProc = "invisible";
     ProcSubset = "pid";
     ProtectSystem = "full";
     RestrictAddressFamilies = [
       "AF_INET"
       "AF_NETLINK"
         ];
     RestrictNamespaces = true;
     MemoryDenyWriteExecute = true;
     SystemCallFilter = [ "@system-service" ];
   }
   ```

2. Coredumps are disabled to prevent leaking sensitive information.

   This is by disabling systemd coredumps, using PAM login limits, and using
   some sysctl options.

3. The emergency and rescue targets and services are disabled.

# Users and Privileges

A single user is created, and is part of the wheel group.

The root account is locked.

Both `run0` and `sudo` are available for privilege elevation. However, `run0` is
preferred and is used in the CLI. `sudo` is also aliased to `run0` in the bash
shell.

Other tools like `su` and `pkexec` are disabled by removing their setuid bit.

# Nix Package Manager

The Nix package manager and the Nix packaging model prevent various classes of
supply chain attacks.

The Nix package manager is hardened and can only be used by members of the wheel
group. Furthermore, only the root user is part of `trusted-users`. This is
important because adding a trusted user is essentially passwordless root.

Nix is also set to only download and use cryptographically signed binaries.
Remote building and copying signed closures can be done using
[seed](./cli.md#build-remote-closures).

Nonfree packages and broken packages are disabled.

Untrusted flake configuration settings are disabled. These may allow the flake
to get root privileges.

# SOPS

[sops-nix](https://github.com/Mic92/sops-nix) is used to store secrets consumed
by the NixOS modules. This ensures that sensitive information does not end up in
the world-readable Nix store. These secrets are encrypted using GPG.

Also, the [bespoke CLI](./cli.md) ensures that the variables file and sops-nix
secrets are **never** committed / pushed to a remote by always unstaging them
after rebuilds, even though secrets are encrypted.

# Encryption and Signing

Age is available for modern encryption. The OpenBSD signify is available for
signing and verification.

# USBGuard

USBGuard is used to protect against rogue USB devices like BadUSB.

The policy is set to allow only patterns defined in the `usbs` list in the
variables file. ALL OTHER devices are blocked. For example, to allow a keyboard:

```nix
usbs = [
  ''id 05f0:0217 serial "" name "Keychron K2" hash "a0ef07fceb6fb77698f79a44a4501218" parent-hash "69d19c1a5733a31e7e6d9530e6k434a6" via-port "1-2" with-interface { 03:01:01 03:01:02 } with-connect-type "hotplug"''
];
```

These descriptors can be found using the `usbguard(1)` command-line interface:

```bash
run0 usbguard list-devices
```

Additionally, devices with the following identifiers are explicitly rejected:

1. Both mass storage device and HID input device

   ```
   reject with-interface all-of { 08:*:* 03:00:* }
   reject with-interface all-of { 08:*:* 03:01:* }
   ```

2. Both mass storage device and wireless controller

   ```
   reject with-interface all-of { 08:*:* e0:*:* }
   ```

3. Both mass storage device and communications device

   ```
   reject with-interface all-of { 08:*:* 02:*:* }
   ```

USBGuard can be controlled using the `usbguard` command line interface. Only the
`root` user is allowed to use the USBGuard IPC.

# Wireless Networking

`wpa_supplicant` is used for wireless connections. Network secrets are stored
using SOPS. WPA3-SAE can be used for these networks.

`hostapd` is used to create wireless access points. Network secrets are stored
using SOPS. WPA3-SAE can be used for these networks.

# DNS

`dnscrypt-proxy` is used for DNS-over-HTTPS with Cloudflare's `1.0.0.2` (malware
blocking).

Additionally, [StevenBlack's host list](http://github.com/StevenBlack/hosts) is
used to blacklist domains (like PiHole, AdGuard).

If enabled, `dnscrypt-proxy` is also used as the DNS server for `hostapd`
clients and `svcvm` guests.

# WireGuard

Server serves services on [WireGuard](https://www.wireguard.com/) over wireless
LAN instead of directly serving over wireless LAN. WireGuard peers are
configured using the variables file and private keys are stored using SOPS.

Note that no services are exposed to the internet, directly or otherwise. Server
serves only its wireless LAN (over WireGuard). Therefore, this is not a concern
and out of scope for this flake.

# Firewall

The simpler NixOS `networking.firewall` is disabled. `nftables` is used instead.
The userspace `nft` tool can be used for ad-hoc changes.

By default (ie, when no services are enabled in variables), **NO** ports are
open on **ANY** interface, not even loopback or internal VM interfaces.

Ports are opened on loopback / wireless LAN / VM interfaces to specific
addresses and interfaces only based on enabled services.

Note that "wireless LAN" here refers to the wireless LAN as configured by
`vars.network.wireless`. This is the primary LAN. The hostapd network
(`vars.network.hostapd`) and WireGuard (`vars.network.wireguard`) are referred
to separately. Nothing is served over wired LAN (`vars.network.wired`).

Only dnscrypt-proxy is served over loopback. In case any apps require loopback,
it can be satisfied using `bwrap --unshare-net`.

dnscrypt-proxy is additionally served on hostapd/svcvm gateways based on enabled
services (see example).

Only SSH is served over wireless LAN and
[uses public key authentication](#secure-shell). Therefore, even though nftables
filters by CIDR using `vars.services.ssh.allow` this is not used as a real
source of identification.

All other services are served over [WireGuard](#wireguard), which uses public
key authentication. Currently this includes

- NGINX https
- I2PD http proxy

Access control to services is derived based on `allow` values in the variables
file. As an illustration, to access the Vaultwarden webvault, clients must
satisfy ALL of:

- in the private LAN CIDR defined by `vars.wireguard.allow`, for nftables
  filtering on LAN
- declared as a peer with public key in `vars.wireguard.peers`, for WireGuard
  tunnelling
- in the private WireGuard CIDR defined by `vars.services.nginx.allow`, for
  nftables filtering on WireGuard
- in the private WireGuard CIDR defined by `vars.services.vaultwarden.allow`,
  for NGINX allow rules

All such access control requirements are documented in the
[Server Usage Documentation](./server/usage.md).

All other ports are opened only to VM interfaces internally since services are
reverse-proxied via NGINX. For the few ports that are opened to wireless LAN
over WireGuard, the ports are opened only to a select private WireGuard CIDR
defined by the `vars.service.<name>.allow` variables in the variables file.
Since this value is a CIDR, it can be used to allow only specific private
ranges. For example, by setting it to `10.20.0.100/31`, only `10.20.0.100` and
`10.20.0.101` are allowed.

Additionally, the services reverse-proxied via the NGINX are also restricted
using `vars.service.<name>.allow`. See [NGINX](#nginx) for more information.

Egress (`output`) through the LAN interface(s) is unrestricted.

Note that all services involve some form of cryptographic authentication -
either SSH public key authentication or WireGuard public key authentication -
and simply being on a "allowed" private CIDR is not sufficient.

> Workstation only

Ports are open based on the enabled services (only SSH).

Ports are opened for the following services:

1. dnscrypt-proxy, if enabled using `vars.services.dnscrypt.enable`:

   - TCP & UDP `53` is open on loopback

   - (hostapd) TCP & UDP `53` is open on the hostapd gateway
     `vars.network.hostapd.address`, if hostapd is enabled

1. SSH, if enabled using `vars.services.ssh.enable`:

   - TCP `vars.services.ssh.port` is open on wireless LAN to the private CIDR
     defined by `vars.services.ssh.allow`

   This port is also open on the hostapd gateway, if hostapd is enabled. If both
   wireless and hostapd are disabled, then it is opened on all interfaces
   (`0.0.0.0`).

1. Libvirt interfaces (`virbr*`) are opened for DNS and DHCP (see example
   below).

> Server only

Ports are open based on the enabled services.

Ports are opened for the following services:

1. dnscrypt-proxy, if enabled using `vars.services.dnscrypt.enable`:

   - TCP & UDP `53` is open on loopback

   - (nginx) TCP & UDP `53` is open on the svcvm interface gateway, if nginx is
     enabled

   - (searxng) TCP & UDP `53` is open on the svcvm interface gateway, if searxng
     is enabled

   - (i2pd) TCP & UDP `53` is open on the svcvm interface gateway, if i2pd is
     enabled

1. SSH, if enabled using `vars.services.ssh.enable`:

   - TCP `vars.services.ssh.port` is open on wireless LAN to the private CIDR
     defined by `vars.services.ssh.allow`

1. NGINX, if enabled using `vars.services.nginx.enable`:

   - (https) TCP `443` is forwarded and open on WireGuard to the private CIDR
     defined by `vars.services.nginx.allow`

1. SearXNG, if enabled using `vars.services.searxng.enable`:

   - (search-engine) TCP `8888` is open internally on VM interface to `nginx` VM

1. Vaultwarden, if enabled using `vars.services.vaultwarden.enable`:

   - Cannot access the internet.

   - (web-vault) TCP `8222` is open internally on VM interface to `nginx` VM

1. I2PD, if enabled using `vars.services.i2pd.enable`:

   - (http-proxy) TCP `4444` is forwarded and open on WireGuard to the private
     CIDR defined by `vars.services.i2pd.allow`

   - (http-proxy) TCP `4444` is open internally on VM interface to `qbt` VM

   - (sam) TCP `7656` is open internally on VM interface to `qbt` VM

   - (web-console) TCP `7070` is open internally on VM interface to `nginx` VM

1. qBittorrent, if enabled using `vars.services.qbt.enable`:

   - Cannot access the internet, exclusively uses I2P.

   - (web-ui) TCP `8080` is open internally on VM interface to `nginx` VM

> Pi only

Ports are open based on the enabled services.

Ports are opened for the following services:

1. dnscrypt-proxy, if enabled using `vars.services.dnscrypt.enable`:

   - TCP & UDP `53` is open on loopback

   - (hostapd) TCP & UDP `53` is open on the hostapd gateway
     `vars.network.hostapd.address`, if hostapd is enabled

1. SSH, if enabled using `vars.services.ssh.enable`:

   - TCP `vars.services.ssh.port` is open on wireless LAN to the private CIDR
     defined by `vars.services.ssh.allow`

   This port is also open on the hostapd gateway, if hostapd is enabled. If both
   wireless and hostapd are disabled, then it is opened on all interfaces
   (`0.0.0.0`).

> Examples

Rulesets are generated based on the enabled services.

Example ruleset for Workstation with

- Wireless enabled
- WireGuard enabled
- Hostapd disabled
- Wired disabled
- dnscrypt-proxy disabled
- SSH disabled

Notes for example:

- `wlan0` is the wireless LAN interface.
- `wg0` is the WireGuard interface.
- `virbr*` are libvirt interfaces.

```
table inet filter {
	chain input {
		type filter hook input priority filter; policy drop;
		ct state invalid drop
		tcp flags & (fin | syn | rst | ack) != syn ct state new drop
		iifname "lo" ct state established,related accept
		iifname "wlan0" ct state established,related accept
		iifname "wg0" ct state established,related accept
		iifname "virbr*" ct state established,related accept
		iifname "virbr*" tcp dport 53 ct state new accept
		iifname "virbr*" udp dport 53 ct state new accept
		iifname "virbr*" udp dport 67 ct state new accept
	}

	chain forward {
		type filter hook forward priority filter; policy drop;
		ct state invalid drop
		ct state established,related accept
		iifname "virbr*" ct state new accept
	}

	chain output {
		type filter hook output priority filter; policy drop;
		ct state invalid drop
		ct state established,related accept
		oifname "lo" accept
		oifname "wlan0" accept
		oifname "wg0" accept
		oifname "virbr*" accept
	}
}
table ip nat {
	chain prerouting {
		type nat hook prerouting priority dstnat; policy accept;
	}

	chain postrouting {
		type nat hook postrouting priority srcnat; policy accept;
	}
}
```

Example ruleset for Workstation with

- Wireless disabled
- WireGuard disabled
- Hostapd enabled
- Wired enabled
- dnscrypt-proxy enabled
- SSH disabled

Notes for example:

- `eth0` is the wired LAN interface
- `wlan0` is the wireless LAN interface, used for hostapd
- `192.168.0.1` is the hostapd gateway
- `virbr*` are libvirt interfaces

```
table inet filter {
	chain input {
		type filter hook input priority filter; policy drop;
		ct state invalid drop
		tcp flags & (fin | syn | rst | ack) != syn ct state new drop
		iifname "lo" ct state established,related accept
		iifname "wlan0" ct state established,related accept
		iifname "eth0" ct state established,related accept
		iifname "wlan0" ip daddr 192.168.0.1 udp dport 53 ct state new accept
		iifname "wlan0" ip daddr 192.168.0.1 tcp dport 53 ct state new accept
		iifname "virbr*" ct state established,related accept
		iifname "virbr*" tcp dport 53 ct state new accept
		iifname "virbr*" udp dport 53 ct state new accept
		iifname "virbr*" udp dport 67 ct state new accept
		ip daddr 127.0.0.1 iifname "lo" udp dport 53 ct state new accept
		ip daddr 127.0.0.1 iifname "lo" tcp dport 53 ct state new accept
	}

	chain forward {
		type filter hook forward priority filter; policy drop;
		ct state invalid drop
		ct state established,related accept
		iifname "wlan0" oifname "eth0" ct state new accept
		iifname "virbr*" ct state new accept
	}

	chain output {
		type filter hook output priority filter; policy drop;
		ct state invalid drop
		ct state established,related accept
		oifname "lo" accept
		oifname "wlan0" accept
		oifname "eth0" accept
		oifname "virbr*" accept
	}
}
table ip nat {
	chain prerouting {
		type nat hook prerouting priority dstnat; policy accept;
	}

	chain postrouting {
		type nat hook postrouting priority srcnat; policy accept;
		iifname "wlan0" oifname "eth0" masquerade
	}
}
```

# Virtualisation

> Workstation only

See
[Workstation Usage Documentation](./workstation/usage.md#virtualisation-and-containers)
for information about virtualisation with QEMU/KVM and libvirt/virt-manager.

It is recommended to set up [Whonix](https://www.whonix.org/) for accessing the
Tor network in an isolated environment. [This](https://www.whonix.org/wiki/KVM)
official wiki page covers setting up Whonix in QEMU/KVM using libvirt.

> Server only

Several services run in Virtual Machines as covered above. These are
[svcvm](https://github.com/sotormd/svcvm) QEMU/KVM `microvm` Virtual Machines.
Networking is covered above in [Firewall](#firewall). Rather than being bridged,
the VMs use a
[routed network model](https://microvm-nix.github.io/microvm.nix/routed-network.html)
with NAT. They use `virtiofs` for shared filesystems and
`io.systemd.credentials` for sharing secrets from the host.

[svcvm](https://github.com/sotormd/svcvm) is a minimal stripped-down derivative
of [microvm.nix](https://github.com/microvm-nix/microvm.nix), which includes
only the features that I require. In this flake, it is used along with
`lib.mksvcvm` which provides things like the `svcready` readiness indicators and
`svcfg` service configuration.

All service virtual machines have the host's Nix Store as a readonly `virtiofs`
share along with a `tmpfs` root. Each VM gets its own interface that it binds to
using `/32` addresses. Inter-VM communication (eg, from vaultwarden to nginx) is
handled by nftables on the host.

See [Server Usage Documentation](./server/usage.md#service-virtual-machines) for
more information.

# MAC Randomization

GNU MAC Changer is used to randomize the MAC address. Using a completely random
MAC address can lead to MAC addresses which are very rare / impossible. This
reduces anonymity significantly. Therefore, only non-vendor bits are randomized.

# Secure Shell

SSH can be enabled on all roles. See role-specific documentation for details
about using a non-default port, authorized keys, etc.

The SSH configuration is hardened using the following options:

1. Only the main user and group is allowed.

2. Root login is disabled.

   ```
   PermitRootLogin no
   ```

3. Only publickey authentication is used. Password authentication is disabled.

   ```
   PubkeyAuthentication yes
   AuthenticationMethods publickey
   PasswordAuthentication no
   PermitEmptyPasswords no
   ```

4. Options are set to reduce the brute-force window

   ```
   MaxSessions 2
   MaxAuthTries 2
   LoginGraceTime 20
   ClientAliveInterval 300
   ClientAliveCountMax 1
   ```

5. Unused features are disabled

   ```
   X11Forwarding no
   AllowStreamLocalForwarding no
   PermitTunnel no
   PermitUserEnvironment no
   KbdInteractiveAuthentication no
   AllowTCPForwarding no
   TCPKeepAlive no
   AllowAgentForwarding no
   ```

6. Secure algorithms are used

   - Post quantum algorithms for key exchange `KexAlgorithms`

     ```
     mlkem768x25519-sha256
     sntrup761x25519-sha512
     curve25519-sha256@libssh.org
     ecdh-sha2-nistp521
     ecdh-sha2-nistp384
     ecdh-sha2-nistp256
     diffie-hellman-group-exchange-sha256
     ```

   - `Ciphers`

     ```
     aes256-gcm@openssh.com
     aes128-gcm@openssh.com
     chacha20-poly1305@openssh.com
     aes256-ctr
     aes192-ctr
     aes128-ctr
     ```

   - Message Authentication Codes `Macs`

     ```
     hmac-sha2-512-etm@openssh.com
     hmac-sha2-256-etm@openssh.com
     umac-128-etm@openssh.com
     hmac-sha2-512
     hmac-sha2-256
     umac-128@openssh.com
     ```

7. Options are set to reduce identity leakage

   ```
   UseDns no
   PrintMotd no
   VersionAddendum none
   ```

8. Options are set to ensure safe filesystem permissions

   ```
   StrictModes yes
   ```

9. Verbose logging is enabled

10. Only a `ed25519` host key is used

11. Authorized keys are defined using `vars.services.ssh.trusted-keys` which
    only accepts `ed25519` keys

12. A nonstandard port can be used using `vars.services.ssh.port`

# NGINX

> Server only

NGINX is used as a reverse proxy for several other services instead of directly
opening ports. This is served over HTTPS with certificates from
[Let's Encrypt](https://letsencrypt.org) managed with ACME. NGINX runs in a
Virtual Machine and is served to the private CIDR as defined by
`vars.services.nginx.allow` over WireGuard.

Furthermore, all the reverse proxy locations are restricted using NGINX `allow`
rules. For example, only the private WireGuard CIDR
`vars.services.vaultwarden.allow` is allowed on the `/vaultwarden/` location.

See [Server Usage Documenation](./server/usage.md#nginx) for more information.

# I2P and Anonymity

> Workstation only

1. I2P

   The I2P network can be browsed using the
   [i2p-browser](./workstation/usage.md#i2p-browser) which uses the I2P HTTP
   Proxy hosted on Server.

2. Tor

   No Tor tooling is installed by default.

   The Tor Browser and oniux can be installed and used in an ad-hoc Nix Shell.
   However, this is discouraged and it is recommended to use Whonix instead. See
   [Virtualisation](#virtualisation).

> Server only

The I2PD router is hosted on Server. It runs in a Virtual Machine. The
qBittorrent torrent client, which also runs in a Virtual Machine, uses the I2P
network via this router and does not have access to the clearnet at all.

# Display Server

> Workstation only

The desktop is 100% wayland, with no X or Xwayland.

# Desktop

> Workstation only

The sway compositor is used with minimal bells and whistles, a simple bar and
some widgets.

XDG desktop portals are disabled.

# Session Locking

> Workstation only

The session is locked using `swaylock` after 60 seconds of inactivity, and
suspended after further inactivity. This behaviour can be controlled using the
waybar [idle_inhibitor Module](./workstation/usage.md#idle_inhibitor-module).

# Bubblewrap

> Workstation only

[Bubblewrap](https://github.com/containers/bubblewrap) is a low-level
unprivileged sandbox utility that is used by projects like
[Flatpak](https://flatpak.org/) and
[rpm-ostree](https://github.com/coreos/rpm-ostree/pull/209).

It provides several useful sandboxing features while maintaining a small focused
codebase. Furthermore, it is not a suid binary.
[Firejail](https://github.com/netblue30/firejail), for example, is another
sandboxing tool but uses suid binaries - which can act as a privilege escalation
hole. Bubblewrap does not have these issues.

Bubblewrap sandboxes can be created using the `bwrap(1)` command-line interface.
All the options used are covered in the browsers section.

# xdg-dbus-proxy

> Workstation only

[xdg-dbus-proxy](https://github.com/flatpak/xdg-dbus-proxy) is a filtering proxy
for D-Bus connections. It is used in conjunction with bubblewrap because it lets
you selectively allow D-Bus connections. Without it, bubblewrap can only enable
D-Bus completely or disable it completely.

It is used on Workstation to let browsers use select D-Bus connections.

# Browsers

> Workstation only

Two hardened browsers are included. See
[Workstation Usage Documentation](./workstation/usage.md#browsers) for more
information about browser usage. This section covers the various hardening flags
in the browsers.

## Brave

1. Runs in a bubblewrap sandbox with xdg-dbus-proxy

   - Bubblewrap args:

     - Bind Nix Store as readonly

       ```
       --ro-bind /nix/store /nix/store
       ```

     - Allow using Wayland

       ```
       --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1"
       ```

     - Bind fake passwd and group files as readonly

       ```bash
       users=$(mktemp -d -p "$XDG_RUNTIME_DIR/bubblewrap-brave" users.XXXXXX)
       echo "brave:x:1000:1000:brave:/home/brave:${coreutils}/bin/false" > "$users/passwd"
       echo "brave:x:1000:" > "$users/group"
       ```

       ```
       --ro-bind "$users/passwd" /etc/passwd
       --ro-bind "$users/group" /etc/group
       ```

     - Bind resolvconf as readonly

       ```
       --ro-bind /etc/resolv.conf /etc/resolv.conf
       ```

     - Bind [StevenBlack's host list](http://github.com/StevenBlack/hosts) as
       readonly

       ```
       --ro-bind ${inputs.hosts.outPath}/alternates/fakenews-gambling-porn/hosts /etc/hosts
       ```

     - Bind fonts as readonly

       ```
       --ro-bind /etc/fonts /etc/fonts
       ```

     - Mount /tmp as tmpfs

       ```
       --tmpfs /tmp
       ```

     - Mount $HOME as tmpfs

       ```
       --setenv HOME /home/brave
       --tmpfs /home/brave
       ```

     - Bind GTK files as readonly

       ```
       --ro-bind /home/${user}/.gtkrc-2.0 /home/brave/.gtkrc-2.0
       --ro-bind /home/${user}/.config/gtk-3.0 /home/brave/.config/gtk-3.0
       --ro-bind /home/${user}/.config/gtk-4.0 /home/brave/.config/gtk-4.0
       --ro-bind /home/${user}/.icons /home/brave/.icons
       --ro-bind /home/${user}/.Xresources /home/brave/.Xresources
       --ro-bind /home/${user}/.local/share/fonts /home/brave/.local/share/fonts
       --ro-bind /home/${user}/.local/share/icons /home/brave/.local/share/icons
       --ro-bind /home/${user}/.local/share/themes /home/brave/.local/share/themes
       --ro-bind /home/${user}/.config/dconf /home/brave/.config/dconf
       ```

     - Mount **new** procfs and dev

       ```
       --proc /proc
       --dev /dev
       ```

     - Unshare all supported namespaces

       ```
       --unshare-all
       ```

     - Share network

       ```
       --share-net
       ```

     - SIGKILL child processes when bubblewrap dies

       ```
       --die-with-parent
       ```

     - Create a new terminal session. Also protects against out-of-sandbox
       command execution.

       ```
       --new-session
       ```

     - Create **new** runtime directory

       ```
       --dir "$XDG_RUNTIME_DIR"
       ```

     - Graphics acceleration. Check `chrome://gpu` to verify status.

       ```
       --dev-bind /dev/dri /dev/dri
       --ro-bind /sys/dev/char /sys/dev/char
       --ro-bind /sys/devices /sys/devices
       --ro-bind /run/opengl-driver /run/opengl-driver
       ```

     - Pipewire

       ```
       --ro-bind "$XDG_RUNTIME_DIR/pipewire-0" "$XDG_RUNTIME_DIR/pipewire-0"
       --ro-bind "$XDG_RUNTIME_DIR/pulse" "$XDG_RUNTIME_DIR/pulse"
       ```

     - Bind Enterprise Policies as readonly

       ```
       --ro-bind ${policies}/extra.json /etc/brave/policies/managed/extra.json
       ```

     - Bind configuration directory

       ```
       --bind /home/${user}/.config/BraveSoftware/Brave-Browser /home/brave/.config/BraveSoftware/Brave-Browser
       ```

     - Bind local state as readonly

       ```
       --ro-bind "${state}/Local State" "/home/brave/.config/BraveSoftware/Brave-Browser/Local State"
       ```

     - Bind downloads directory

       ```
       --bind /home/${user}/Downloads /home/brave/Downloads
       ```

   - xdg-dbus-proxy:

     - Allow `org.mpris.MediaPlayer2` for use with `playerctl`

       ```bash
       proxy_dir=$(mktemp -d)
       proxy_socket="$proxy_dir/bus"

       xdg-dbus-proxy "$DBUS_SESSION_BUS_ADDRESS" "$proxy_socket" \
       --filter \
       --own="org.mpris.MediaPlayer2.*" \
       --talk="org.mpris.MediaPlayer2.*" & proxy_pid=$!
       ```

     - Bind this proxy directory using bubblewrap

       ```
       --bind "$proxy_socket" "$XDG_RUNTIME_DIR/bus"
       ```

2. Several
   [Chrome Enterprise Policies](https://chromeenterprise.google/policies) and
   some
   [Brave-Specific Policies](https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy)
   are used to harden the browser. Some of them involve:

   - Disabling several Brave anti-features like:
     - Brave Rewards
     - Brave Wallet
     - Brave VPN
     - Brave AI Chat
     - Brave News
     - Brave Talk
     - Brave Speedreader
     - Brave Wayback Machine
     - Brave P3A (Privacy Preserving Product Analytics)
     - Brave Stats Ping
     - Brave Web Discovery
     - Brave Playlist
     - Tor (breaks anonymity)

   - Enabling useful Brave features:
     - Brave DeAmp
     - Brave Debouncing
     - Brave Reduce Language Fingerprinting

   - Default block some permissions and content:
     - Clipboard
     - Geolocation
     - Insecure Content
     - Notifications
     - Popups
     - Sensors
     - Bluetooth
     - Hid
     - Usb
     - Intrusive Ads
     - Non-Proxied UDP

   - Disable telemetry, services that require sending data to Google, and other
     features to reduce attack surface:
     - V8 JavaScript JIT
     - V8 JavaScript Optimizations
     - Metrics
     - Feedback Surveys
     - User Feedback
     - Safe Browsing Extended Reporting
     - Safe Browsing Deep Scanning
     - Advanced Protection
     - Domain Reliability
     - Network Time Queries
     - Keyed Anonymization Data Collection
     - Accesibility Image Labels
     - Media Recommendations
     - Password Manager
     - Autofill
     - Add Profile
     - PDF Reader
     - External Extensions
     - Shopping List
     - Search Suggest
     - Spellcheck
     - Live Translate
     - Media Router
     - Sync
     - Promotions
     - Dinosaur Easter Egg
     - Printing
     - Bookmark Bar
     - Third Party Cookies
     - Background Apps
     - Autoplay
     - Payment Method Query
     - DNS over HTTPS (in favor of system resolver)

   - Use Site Per Process
   - Use Strict HTTPS-Only Mode
   - Use SearXNG as Search Engine

3. Preferences file settings

   - Auto redirect amp pages
   - Auto redirect tracking URLs
   - Prevent language fingerprinting
   - Automatically remove unused permissions
   - Aggressive trackers and ads blocking
   - Block fingerprinting
   - Block third party cookies
   - Strict HTTPS upgrades
   - Disable V8 JavaScript JIT
   - Disable WebTorrent
   - Disable social media components
   - Disable Google push messaging services
   - Disable saving contact information
   - Disable search suggestions
   - Limit autocompletions to history only

4. Local state file settings

   - Disable Brave P3A
   - Disable Brave stats reporting
   - Disable user experience metrics reporting

5. Extensions (no MV2)

   - uBlock Origin Lite
   - Dark Reader
   - Vimium

## I2P Browser

1. Runs in a bubblewrap sandbox

   - Bubblewrap args:

     - Bind Nix Store as readonly

       ```
       --ro-bind /nix/store /nix/store
       ```

     - Allow using Wayland

       ```
       --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1"
       ```

     - Bind fake passwd and group files as readonly

       ```bash
       users=$(mktemp -d -p "$XDG_RUNTIME_DIR/bubblewrap-i2p-browser" users.XXXXXX)
       echo "i2p-browser:x:1000:1000:i2p-browser:/home/i2p-browser:${coreutils}/bin/false" > "$users/passwd"
       echo "i2p-browser:x:1000:" > "$users/group"
       ```

       ```
       --ro-bind "$users/passwd" /etc/passwd
       --ro-bind "$users/group" /etc/group
       ```

     - Bind resolvconf as readonly

       ```
       --ro-bind /etc/resolv.conf /etc/resolv.conf
       ```

     - Bind fonts as readonly

       ```
       --ro-bind /etc/fonts /etc/fonts
       ```

     - Mount /tmp as tmpfs

       ```
       --tmpfs /tmp
       ```

     - Mount $HOME as tmpfs

       ```
       --setenv HOME /home/i2p-browser
       --tmpfs /home/i2p-browser
       ```

     - Bind GTK files as readonly

       ```
       --ro-bind /home/${user}/.gtkrc-2.0 /home/i2p-browser/.gtkrc-2.0
       --ro-bind /home/${user}/.config/gtk-3.0 /home/i2p-browser/.config/gtk-3.0
       --ro-bind /home/${user}/.config/gtk-4.0 /home/i2p-browser/.config/gtk-4.0
       --ro-bind /home/${user}/.icons /home/i2p-browser/.icons
       --ro-bind /home/${user}/.Xresources /home/i2p-browser/.Xresources
       --ro-bind /home/${user}/.local/share/fonts /home/i2p-browser/.local/share/fonts
       --ro-bind /home/${user}/.local/share/icons /home/i2p-browser/.local/share/icons
       --ro-bind /home/${user}/.local/share/themes /home/i2p-browser/.local/share/themes
       --ro-bind /home/${user}/.config/dconf /home/i2p-browser/.config/dconf
       ```

     - Mount **new** procfs and dev

       ```
       --proc /proc
       --dev /dev
       ```

     - Unshare all supported namespaces

       ```
       --unshare-all
       ```

     - Share network

       ```
       --share-net
       ```

     - SIGKILL child processes when bubblewrap dies

       ```
       --die-with-parent
       ```

     - Create a new terminal session. Also protects against out-of-sandbox
       command execution.

       ```
       --new-session
       ```

2. Firefox policies:

   - Disabled features:
     - Auto update
     - Autofill address
     - Autofill credit card
     - Background updates
     - About addons page
     - About config page
     - About profiles page
     - About support page
     - Accounts
     - PDF viewer
     - Developer tools
     - Feedback commands
     - Firefox accounts
     - Firefox screenshots
     - Firefox studies
     - Forget button
     - Form history
     - Master password creation
     - Password reveal
     - Pocket
     - Profile import
     - Profile refresh
     - Security bypass
     - Set desktop background
     - System addon update
     - Telemetry
     - Bookmarks toolbar
     - Check default browser
     - Encrypted media extensions
     - Firefox home items
     - Firefox suggest
     - HTTPS only mode (disabled for i2p)
     - Install addons permission
     - Microsoft Entra SSO
     - Default bookmarks
     - Save logins
     - First run page
     - Post update page
     - Password manager
     - PDFjs
     - Picture-in-picture
     - Printing
     - Search suggest
     - Home button
     - Show terms of use
     - Translate
     - WindowsSSO

   - Enabled features:
     - Start downloads in temp directory
     - Prompt for download location
     - Sanitize on shutdown
     - Post quantum key agreement
     - Tracking protection from Cryptomining, Fingerprinting and Email Tracking
     - Encrypted client hello

3. Profile options

   - Use I2P HTTP proxy
   - Disable suggestions except history
   - Enable resist fingerprinting
   - Disable JavaScript

   - Default deny permissions:
     - Camera
     - Desktop notification
     - Geolocation
     - Microphone
     - Screen wake lock
     - xr
     - Shortcuts

# Search Engine

The SearXNG metasearch engine is hosted on Server. It runs in a Virtual Machine.
See [Server Usage Documentation](./server/usage.md#searxng) for information
about default search engines.

The Brave Browser uses SearXNG as the default search engine.

# Password Manager

The Vaultwarden password manager is hosted on Server. It runs in a Virtual
Machine and does not have access to the internet.

# Kernel Parameters

Kernel parameters should only be considered as a baseline.

Several kernel parameters are used to harden the kernel. They are covered below:

1. disables merging of slabs of similar sizes

   sometimes, vulnerable slabs may be merged with safe ones

   slight increase in kernel memory utilization

   ```
   slab_nomerge
   ```

2. enable zeroing of memory during allocation and free time

   mitigate use-after-free vulnerabilities and erase sensitive data also enables
   poisoning for some freed memory

   little performance cost

   ```
   init_on_alloc=1
   init_on_free=1
   ```

3. randomise page allocator freelists

   makes page allocations less predictable

   ```
   page_alloc.shuffle=1
   ```

4. enable kernel page table isolation

   mitigates meltdown and prevents some KASLR bypasses

   ```
   pti=on
   ```

5. randomize kernel stack offset on each syscall

   mitigates attacks reliant on deterministic kernel stack layouts

   ```
   randomize_kstack_offset=on
   ```

6. disable obsolete vsyscalls

   replaced by vDSO calls

   ```
   vsyscall=none
   ```

7. disable debugfs

   debugfs exposes sensitive kernel information

   ```
   debugfs=off
   ```

8. panic on oops

   some kernel exploits will cause an "oops"

   this will cause the kernel to panic on such oopses, preventing the exploit

   sometimes, bad drivers cause harmless oopses, resulting in system crashes

   ```
   oops=panic
   ```

9. ~~enforce signed modules~~

   ~~only allows kernel modules that have been signed with a valid key to be
   loaded makes it harder to load a malicious kernel module~~

   ~~virtualbox, nvidia modules may need manual signing~~

   **since MODULE_SIG is disabled on NixOS, this does nothing**

   this parameter is still kept for reference/future use with custom kernels

   ```
   module.sig_enforce=1
   ```

10. ~~enable the kernel lockdown LSM~~

    ~~confidentiality is the strictest mode protects both kernel integrity and
    prevents unauthorized access to kernel data~~

    ~~establishes clear security boundary between userspace and kernel~~

    ~~this implies `module.sig_enforce=1`~~

    **since LOCKDOWN_LSM is disabled on NixOS, this does nothing**

    this parameter is still kept for reference/future use with custom kernels

    ```
    lockdown=confidentiality
    ```

11. do not panic on uncorrectable memory errors

    this causes the kernel to panic on uncorrectable errors in ECC memory which
    could be exploited

    since we do not use ECC memory, this is unnecessary anyways and can be
    disabled with this parameter

    ```
    mce=0
    ```

12. mitigate spectre vulnerabilities

    ```
    spectre_v2=on
    spec_store_bypass_disable=on
    ```

13. do not trust the proprietary cpu RNG

    this RNG cannot be audited

    ```
    random.trust_cpu=off
    random.trust_bootloader=off
    ```

14. enable IOMMU

    mitigates direct memory access attacks

    ```
    intel_iommu=on
    amd_iommu=on
    ```

15. fix a hole in IOMMU

    disables busmaster bit on all PCI bridges in early boot

    ```
    efi=disable_early_pci_dma
    ```

16. force KVM to mark huge pages as non-executable

    prevents code execution in certain memory regions

    can increase memory usage, especially with KVM-based hypervisors

    ```
    kvm.nx_huge_pages=force
    ```

17. prevent kaudit overflow

    ```
    audit_backlog_limit=8192
    ```

18. disable IPv6

    note that disabling IPv6 has no security benefit whatsoever, I just do not
    require it

    ```
    ipv6.disable=1
    ```

19. disable nested KVM

    steady source of guest-to-host escapes recently (see Januscape, Zapscape)

    ```
    kvm_intel.nested=0
    kvm_amd.nested=0
    ```

unused parameters due to high performance costs:

```
# disable hyperthreading - for both amd and intel
# also disable TSX and mitigate TAA - mostly for intel
# also mitigate speculative execution vulnerabilities - mostly for intel
# dramatic performance losses
#"nosmt=force"
#"tsx=off"
#"tsx_async_abort=full,nosmt"
#"l1tf=full,force"
#"mds=full,nosmt"
```

# sysctl Options

sysctl options should only be considered as a baseline.

Several sysctl options are used to harden the kernel. They are covered below:

1. enable ASLR

   randomises memory space for stack, heap, memory mappings and shared libraries

   ```
   kernel.randomize_va_space=2
   ```

2. disable magic SysRq key

   ```
   kernel.sysrq=0
   ```

3. restrict access to kernel pointers via /proc

   ```
   kernel.kptr_restrict=2
   ```

4. only allow access to kernel log messages for privileged users

   ```
   kernel.dmesg_restrict=1
   ```

5. disable unprivileged calls to berkeley packet filter

   ```
   kernel.unprivileged_bpf_disabled=1
   ```

6. disable ability to load a new kernel while system is running

   ```
   kernel.kexec_load_disabled=1
   ```

7. control use of performance events system by unprivileged users

   `>=2` disallows kernel profiling by unprivileged users

   ```
   kernel.perf_event_paranoid=3
   ```

8. limit cpu time that can be accounted for performance events to 1%

   ```
   kernel.perf_cpu_time_max_percent=1
   ```

9. limit sample rate for performance events to 1

   ```
   kernel.perf_event_max_sample_rate=1
   ```

10. disable ptrace with yama LSM

    ```
    kernel.yama.ptrace_scope=3
    ```

11. disable function tracing

    ```
    kernel.ftrace_enabled=0
    ```

12. disable io_uring

    https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html

    ```
    kernel.io_uring_disabled=2
    ```

13. prevent auto loading line disciplines for tty

    ```
    dev.tty.ldisc_autoload=0
    ```

14. disable core dumps for setuid programs

    ```
    fs.suid_dumpable=0
    ```

15. restrict creation of hard links to files owned by other users

    ```
    fs.protected_hardlinks=1
    ```

16. restrict creation of symlinks to files owned by other users

    ```
    fs.protected_symlinks=1
    ```

17. controls permissions for named pipes

    only owner of the FIFO can write to it

    ```
    fs.protected_fifos=2
    ```

18. restrict access to regular files by non-root users if the file is owned by
    another user

    ```
    fs.protected_regular=2
    ```

19. disable the berkeley packet filter JIT

    ```
    net.core.bpf_jit_enable=0
    ```

20. enable JIT hardening techniques like constant blinding

    note that JIT is disabled anyways

    ```
    net.core.bpf_jit_harden=2
    ```

21. protect against SYN flood attacks

    ```
    net.ipv4.tcp_syncookies=1
    ```

22. protect against time-wait assassination by dropping RST packets

    ```
    net.ipv4.tcp_rfc1337=1
    ```

23. enable source validation of received packets from all interfaces

    protect against IP spoofing

    ```
    net.ipv4.conf.all.rp_filter=1
    net.ipv4.conf.default.rp_filter=1
    ```

24. disable ICMP redirect acceptance and sending

    prevent MITM attacks

    ```
    net.ipv4.conf.all.accept_redirects=0
    net.ipv4.conf.default.accept_redirects=0
    net.ipv4.conf.all.secure_redirects=0
    net.ipv4.conf.default.secure_redirects=0
    net.ipv4.conf.all.send_redirects=0
    net.ipv4.conf.default.send_redirects=0
    net.ipv6.conf.all.accept_redirects=0
    net.ipv6.conf.default.accept_redirects=0
    ```

25. ignore all ICMP requests

    prevent smurf attacks and clock fingerprinting

    note that this is more of a stealth thing, no real security benefits

    ```
    net.ipv4.icmp_echo_ignore_all=1
    net.ipv4.icmp_echo_ignore_broadcasts=1
    ```

26. disable source routing

    prevent MITM attacks

    ```
    net.ipv4.conf.all.accept_source_route=0
    net.ipv4.conf.default.accept_source_route=0
    net.ipv6.conf.all.accept_source_route=0
    net.ipv6.conf.default.accept_source_route=0
    ```

27. disable TCP SACK

    note that disabling SACK isn't really necessary on modern kernels, but this
    is kept since it's
    [commonly exploited](https://github.com/Netflix/security-bulletins/blob/master/advisories/third-party/2019-001.md)
    and mostly unnecessary

    ```
    net.ipv4.tcp_sack=0
    net.ipv4.tcp_dsack=0
    net.ipv4.tcp_fack=0
    ```

28. log martian packets

    ```
    net.ipv4.conf.all.log_martians=1
    net.ipv4.conf.default.log_martians=1
    ```

29. disable IPv6 router advertisements

    prevent MITM attacks

    ```
    net.ipv6.conf.all.accept_ra=0
    net.ipv6.conf.default.accept_ra=0
    ```

30. generate a random IPv6 address every time

    IPv6 addresses are tied to MAC address, making them unique for each device

    ```
    net.ipv6.conf.all.use_tempaddr=2
    net.ipv6.conf.default.use_tempaddr=2
    ```

31. disable tcp timestamps

    tcp timestamps leak the system time

    kernel attempts to mitigate this by adding random offsets but that is not
    sufficient

    ```
    net.ipv4.tcp_timestamps=0
    ```

32. disable the often-abused userfaultfd() syscall

    ```
    vm.unprivileged_userfaultfd=0
    ```

33. increase bits of entropy used for mmap ASLR

    ```
    vm.mmap_rnd_compat_bits=16
    ```

    ```
    vm.mmap_rnd_bits=33 (for aarch64-linux)
    vm.mmap_rnd_bits=32 (for other architectures)
    ```

34. do not print unnecessary things during boot

    ```
    kernel.printk="3 3 3 3"
    ```

# Module Blacklists

Module blacklists should only be considered as general attack surface reduction.

Several kernel modules are blacklisted to reduce the attack surface. They are
covered below:

1. datagram congestion control protocol

   manages congestion without providing reliable data delivery

   can blacklist unless using voice-over-IP

   ```
   dccp
   ```

2. stream control transmission protocol

   like tcp but with support for multiple streams

   can blacklist unless involved in telecoms or signalling

   ```
   sctp
   ```

3. reliable datagram sockets

   high performance clustered computing and inter-process communication

   can blacklist unless running distributed systems

   ```
   rds
   ```

4. transparent inter-process communication

   cluster-wide communication in systems like databases/clustered servers

   can blacklist unless running clustered environments

   ```
   tipc
   ```

5. high-level data link control

   serial communication and networking over physical links

   can blacklist unless using specialized serial networking hardware

   ```
   n-hdlc
   ```

6. amateur radio X.25 protocol

   amateur radio communication

   can blacklist unless a radio operator

   ```
   ax25
   ```

7. network layer protocol used in AX.25

   ```
   netrom
   ```

8. X.25 protocol

   packet-switched network protocol

   can blacklist unless using legacy networking systems

   ```
   x25
   ```

9. amateur radio link layer

   packet radio communication

   can blacklist unless a radio operator

   ```
   rose
   ```

10. digital equipment corporation network

    DEC network protocol for its proprietary systems

    can blacklist unless using legacy DEC equipment

    ```
    decnet
    ```

11. Acorn Computers' networking protocol

    proprietary network protocol developed by Acorn

    can blacklist unless using legacy Acorn equipment

    ```
    econet
    ```

12. IEEE 802.15.4 protocol family

    low-rate wireless personal area networks (LR-WPANs), mostly for IoT devices

    can blacklist unless dealing with IoT

    ```
    af_802154
    ```

13. internetwork packet exchange

    Novell protocol used in legacy networks

    can blacklist unless using old Novell networks

    ```
    ipx
    ```

14. AppleTalk protocol

    network protocol developed by Apple

    can blacklist unless using legacy Mac systems

    ```
    appletalk
    ```

15. subnetwork access protocol

    transmitting packets over different types of physical networks

    can blacklist unless dealing with low-level networking

    ```
    psnap
    ```

16. IEEE 802.3 and 802.2

    legacy networking standard for ethernet communication

    can blacklist unless using legacy ethernet

    ```
    p8023
    p8022
    ```

17. controller area network

    communication in vehicles and industrial systems

    can blacklist unless dealing with embedded/automotive systems

    ```
    can
    ```

18. asynchronous transfer mode

    used in old telecommunications networks

    can blacklist unless using legacy telecom equipment

    ```
    atm
    ```

19. rare filesystems

    can blacklist if not using

    ```
    cramfs
    freexvfs
    jffs2
    hfs
    hfsplus
    squashfs
    udf
    overlay
    adfs
    affs
    bfs
    befs
    efs
    erofs
    exofs
    f2fs
    hpfs
    jfs
    minix
    nilfs2
    omfs
    qnx4
    qnx6
    sysv
    ufs
    ```

20. network filesystems

    can blacklist if not using

    ```
    cifs
    nfs
    nfsv3
    nfsv4
    sunrpc
    lockd
    ksmbd
    gfs2
    ```

21. virtual video driver

    can blacklist unless testing video drivers

    ```
    vivid
    ```

22. IEEE 1394

    high-speed interface for video cameras, external drives, etc replaced by usb
    3.0 and usb c

    can blacklist unless using old firewire devices

    ```
    firewire-core
    ```

23. bluetooth

    can blacklist unless using bluetooth

    ```
    bluetooth
    btusb
    ```

24. annoying PC speaker module

    can blacklist unless deaf

    ```
    pcspkr
    ```

25. dirtyfrag mitigation

    ```
    esp4
    esp6
    rxrpc
    ```
