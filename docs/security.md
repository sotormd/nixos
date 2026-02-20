# Security and Privacy

Several security- and privacy-focused design decisions were made while building
the included modules. This section summarizes the most important protections and
defaults.

Some privacy features depend on the `server` role.

Disabling `vars.network.server.enable` on the `laptop` reduces available privacy
guarantees.

# Threat Model

This configuration is designed to mitigate:

- offline data access after device loss or theft
- persistence of system compromise across reboots
- unnecessary network exposure
- metadata leakage from DNS and search queries
- supply-chain risks from unsigned software

It does not attempt to defend against hardware compromise, malicious firmware,
or targeted nation-state attacks.

# Mitigations

## Encryption

Full-disk encryption is implemented using LUKS with a passphrase on the root
partition on `laptop`.

Additional protections include:

- Support for LUKS-encrypted external disks via `vars.device.luks`
- Randomly encrypted swap space to prevent data recovery from swap on `laptop`

These measures protect data at rest against offline access.

## Secure Boot

Secure Boot is enabled on `laptop` using the lanzaboote project, ensuring that
only signed boot components and kernel modules are executed during system
startup.

This prevents unauthorized kernel or bootloader modification.

See [secureboote.md](./laptop/secureboot.md).

## Impermanence

The `laptop` role implements an **opt-in persistence model** using ZFS snapshots
and bind mounts.

System datasets are rolled back to clean snapshots at boot, ensuring that only
explicitly allowed files and directories persist across reboots. This limits the
impact of compromise and prevents long-term state accumulation.

See [impermanence.md](./laptop/impermanence.md).

## Kernel Hardening

The system uses the `linux-hardened` kernel together with additional hardening
measures, including:

- restrictive kernel parameters
- hardened sysctl settings
- kernel module blacklisting

These settings reduce attack surface and mitigate common privilege-escalation
and information-leak vectors.

## Auditing

The Linux auditing subsystem is enabled with rules inspired by security
technical implementation guides (STIGs).

Audit logging improves visibility into privileged actions and potential system
misuse.

## Users and Privilege Model

The system follows a least-privilege model:

- A single primary user account is used.
- The root account is disabled.
- Administrative actions require `sudo`.
- Only trusted users belong to the `wheel` group.

This minimizes exposure of unrestricted root access.

## Firewall

The firewall operates with a default-deny policy:

- All ports closed by default
- All interfaces treated as untrusted

Ports are opened only when required by active services.

ZERO ports are open on the `laptop` role.

On the `server` role, most services are exposed internally through a reverse
proxy. Only selected ports are accessible within a configurable network range,
allowing access to be restricted to specific hosts or subnets. For example, by
setting `vars.network.range` to `10.0.0.99/31`, only two specific IPs can be
allowed.

## Application Sandboxing

Browsers are isolated using Firejail sandboxing.

All firejail wrappers run with several hardening flags, reducing the impact of
potential sandbox escape vulnerabilities.

## Nix Package Manager Security

The Nix package manager is configured to:

- accept only cryptographically signed binaries
- restrict package management operations to trusted users

This protects against supply-chain attacks and unauthorized system changes.

## Passwords and Secrets

### Vaultwarden

A self-hosted Vaultwarden instance provides secure password and secret storage.
Client systems access it through a browser extension.

### Secret Management

System secrets are managed using `sops-nix` with GPG encryption.

Secrets remain encrypted at rest, are decrypted only during activation, and are
not stored in version control.

## DNS Privacy

DNS queries are resolved using an Unbound recursive resolver with DNSSEC
validation enabled.

Client systems query the server resolver to reduce external metadata exposure.

Fallback resolvers are limited to privacy-focused public DNS providers.

## Private Search

Search queries are routed through a self-hosted SearXNG metasearch instance,
providing aggregated results without exposing user queries directly to search
providers.

A privacy-respecting public search engine, DuckDuckGo, is used as fallback.

## SSH

- The `laptop` role disables the SSH daemon entirely.
- The `server` role enables SSH using hardened configuration settings.

Access can be restricted to specific network ranges.

## Anonymity Networks

### I2P

An I2P router, I2PD, is provided for anonymous network access. Supported
applications, including the bundled qBittorrent-nox web client on `server` and
the i2p-browser on `laptop`, can operate over the I2P network.

### Tor

Kernel-level Tor isolation is available for applications through a dedicated
wrapper.

Browsers should use Tor Browser directly rather than application wrapping to
avoid fingerprinting risks.

The Tor Browser is not installed, but can be used using:

```bash
nix shell nixpkgs#tor-browser -c tor-browser
```
