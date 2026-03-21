# Security

This document covers the various security features for the Laptop and Server
roles.

This is a larger document than other documents in this flake. It is possible
that errors may have crept in while writing this document. In any case, the
flake source should be referred to as the primary and only source of truth.

# Resources

- [Madaidan's Insecurities](https://madaidans-insecurities.github.io/guides/linux-hardening.html)
- [Kicksecure System Hardening Checklist](https://www.kicksecure.com/wiki/System_Hardening_Checklist)
- [Tails Kernel Hardening](https://tails.net/contribute/design/kernel_hardening/)
- [ArchWiki - Security](https://wiki.archlinux.org/title/Security)
- [Paranoid NixOS - Xe Iaso](https://xeiaso.net/blog/paranoid-nixos-2021-07-18/)

# Known Issues

Warnings:

- Several hardening options may hinder performance.

Missing features:

- AppArmor/SELinux support is not great under NixOS.
- LKRG (Linux Kernel Runtime Guard) does not work under NixOS.
- LOCKDOWN_LSM and MODULE_SIG are disabled in the kernel
  [upstream](https://github.com/NixOS/nixpkgs/blob/baeac6edff1b03f0ecd063b8fe48e9742d0527e7/pkgs/os-specific/linux/kernel/common-config.nix#L830)
  to ensure reproducibility.

# Contents

1. [Secure Boot](#secure-boot)
2. [Entropy](#entropy)
3. [Memory Allocator](#memory-allocator)
4. [Filesystems](#filesystems)
5. [Impermanence](#impermanence)
6. [Kernel](#kernel)
7. [Kernel Parameters](#kernel-parameters)
8. [sysctl Options](#sysctl-options)
9. [Module Blacklists](#module-blacklists)
10. [Audit Subsystem](#audit-subsystem)
11. [Coredumps](#coredumps)
12. [Emergency and Rescue](#emergency-and-rescue)
13. [Systemd Services](#systemd-services)
14. [Users and Privileges](#users-and-privileges)
15. [Nix Package Manager](#nix-package-manager)
16. [SOPS](#sops)
17. [USBGuard](#usbguard)
18. [Wireless Networking](#wireless-networking)
19. [DNS](#dns)
20. [Firewall](#firewall)
21. [MAC Randomization](#mac-randomization)
22. [Secure Shell](#secure-shell)
23. [Fail2Ban](#fail2ban)
24. [I2P and Anonymity](#i2p-and-anonymity)
25. [Display Server](#display-server)
26. [Session Locking](#session-locking)
27. [Bubblewrap](#bubblewrap)
28. [xdg-dbus-proxy](#xdg-dbus-proxy)
29. [Browsers](#browsers)
30. [Search Engine](#search-engine)
31. [Password Manager](#password-manager)
32. [Virtualisation and Containers](#virtualisation-and-containers)

# Secure Boot

> Laptop only

Secure Boot is used to ensure that the bootloader is signed before loading.
Secure Boot support for NixOS is provided by the
[lanzaboote](https://github.com/nix-community/lanzaboote) project.

Note that Secure Boot can only be enabled post-installation. See
[Setting up Secure Boot](./laptop/setup.md#setting-up-secure-boot).

# Entropy

[Jitterentropy](https://github.com/smuellerDD/jitterentropy-library) is used to
improve RNG quality by providing a noise source using the CPU execution jitter.

The hardware RNGS are not trusted. This is done using the following kernel
parameters:

```
random.trust_cpu=off
random.trust_bootloader=off
```

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

2. ZFS

   ZFS, which provides advanced self-healing capabilities and administraton, is
   supported out-of-the-box.

   It is the also root filesystem on Laptop.

3. Encrypted Mounts

   Also, LUKS encrypted mounts can be added using the variables file. See
   [Additional Disks and Mounts](./filesystems.md#additional-disks-and-mounts).

4. Filesystem hardening sysctls

   Several `fs.*` sysctls are set. See [sysctl Options](#sysctl-options).

> Laptop only

LUKS encryption with a passphrase is enabled for the root partition, containing
the main ZFS rpool.

Random encryption is used on the swap partition.

# Impermanence

Impermanence ensures a clean filesystem after every reboot. Only explicitly
declared state survives across reboots, and anything else is purged. This
greatly reduces the persistent attack surface.

Impermanence is implemented differently on the Laptop and Server role, without
using the [library](https://github.com/nix-community/impermanence), using either
ZFS Snapshots or tmpfs for rollbacks and bind mounts for state persistence.

See [Impermanence](./filesystems.md#impermanence).

# Kernel

The `linux-hardened` kernel from Nixpkgs is used.

[Upstream URL](https://github.com/anthraxx/linux-hardened).

# Kernel Parameters

Several kernel parameters are used to harden the kernel. They are covered below:

1. disables merging of slabs of similar sizes

   sometines, vulnerable slabs may be merged with safe ones

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

   slightly improves performace

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

9. enforce signed modules

   only allows kernel modules that have been signed with a valid key to be
   loaded makes it harder to load a malicious kernel module

   virtualbox, nvidia modules may need manual signing

   since MODULE_SIG is disabled on NixOS, this does nothing

   ```
   module.sig_enforce=1
   ```

10. enable the kernel lockdown LSM

    confidentiality is the strictest mode protects both kernel integrity and

    prevents unauthorized access to kernel data establishes clear security
    boundary between userspace and kernel

    this implies `module.sig_enforce=1`

    since LOCKDOWN_LSM is disabled on NixOS, this does nothing

    ```
    lockdown=confidentiality
    ```

11. panic on uncorrectable memory errors

    kernel will panic on uncorrectable memory errors

    mainly for systems with ECC memory

    ```
    mce=0
    ```

12. mitigate spectre vulnerabilities

    ```
    spectre_v2=on
    spec_store_bypass_disable=on
    ```

13. do not trust the proprietary cpu RNG

    this RNG can not be audited

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

17. quiet boot

    do not print unnecessary text during boot

    prevent malicious screenreaders from capturing system logs

    ```
    quiet
    loglevel=3
    rd.systemd.show_status=false
    rd.udev.log_level=3
    udev.log_priority=3
    ```

18. prevent kaudit overflow

    ```
    audit_backlog_limit=8192
    ```

19. disable IPv6

    ```
    ipv6.disable=1
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

Several kernel parameters are used to harden the kernel. They are covered below:

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

   > =2 disallows kernel profiling by unprivileged users

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

11. disable unprivileged user namespaces

    ```
    kernel.unprivileged_userns_clone=0
    ```

    > NOTE: Browsers and distrobox containers require this feature to be
    > enabled, and it can be enabled on demand on a as-needed basis by the user
    > using the waybar [userns](./laptop/usage/md#userns-module) module.

12. disable function tracing

    ```
    kernel.ftrace_enabled=0
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

    only owned of the FIFO can write to it

    ```
    fs.protected_fifos=2
    ```

18. restrict access to regular files by non-root users if the file is owned by
    another user

    ```
    fs.protected_regular=2
    ```

19. disable the berkely packet filter JIT

    ```
    net.core.bpf_jit_enable=0
    ```

20. enable JIT hardening techniques like constant blinding

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

    commonly exploited and mostly unnecessary

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

    > This is set to 32 on Laptop

34. do not print unnecessary things during boot

    ```
    kernel.printk="3 3 3 3"
    ```

# Module Blacklists

Several kernel modules are blacklisted to reduce the attack surface. They are
covered below:

1. datagram congestion control protocol

   manages congestion without providing reliable data delivery can blacklist
   unless using voice-over-IP

   ```
   dccp
   ```

2. stream control transmission protocol

   like tcp but with support for multiple streams can blacklist unless involved
   in telecoms or signalling

   ```
   sctp
   ```

3. reliable datagram sockets

   high performance clustered computing and inter-process communication can
   blacklist unless running distributed systems

   ```
   rds
   ```

4. transparent inter-process communication

   cluster-wide communication in systems like databases/clustered servers can
   blacklist unless running clustered environments

   ```
   tipc
   ```

5. high-level data link control

   serial communication and networking over physical links can blacklist unless
   using specialized serial networking hardware

   ```
   n-hdlc
   ```

6. amateur radio X.25 protocol

   amateur radio communication can blacklist unless a radio operator

   ```
   ax25
   ```

7. network layer protocol used in AX.25

   ```
   netrom
   ```

8. X.25 protocol

   packet-switched network protocol can blacklist unless using legacy networking
   systems

   ```
   x25
   ```

9. amateur radio link layer

   packet radio communication can blacklist unless a radio operator

   ```
   rose
   ```

10. digital equipment corporation network

    DEC network protocol for its proprietary systems can blacklist unless using
    legacy DEC equipment

    ```
    decnet
    ```

11. Acorn Computers' networking protocol

    proprietary network protocol developed by Acorn can blacklist unless using
    legacy Acorn equipment

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

    Novell protocol used in legacy networks can blacklist unless using old
    Novell networks

    ```
    ipx
    ```

14. AppleTalk protocol

    network protocol developed by Apple can blacklist unless using legacy Mac
    systems

    ```
    appletalk
    ```

15. subnetwork access protocol

    transmitting packets over different types of physical networks can blacklist
    unless dealing with low-level networking

    ```
    psnap
    ```

16. IEEE 802.3 and 802.2

    ethernet-based networking standard for ethernet communication can blacklist
    unless using ethernet (eg. only using wifi)

    ```
    p8023
    p8022
    ```

17. controller area network

    communication in vehicles and industrial systems can blacklist unless
    dealing with embedded/automotive systems

    ```
    can
    ```

18. asynchronous transfer mode

    used in old telecommunications networks can blacklist unless using legacy
    telecom equipment

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

    high-speed interface for video cameras, external drives, etc replacd by usb
    3.0 and usb c can blacklist unless using old firewire devices

    ```
    firewire-core
    ```

23. intel thunderbolt

    high-speed data and power transfer can blacklist unless using thunderbolt

    ```
    thunderbolt
    ```

24. bluetooth

    can blacklist unless using bluetooth

    ```
    bluetooth
    btusb
    ```

25. usb video class devices

    can blacklist unless using webcam

    ```
    uvcvideo
    ```

26. annoying PC speaker module

    can blacklist unless deaf

    ```
    pcspkr
    ```

# Audit Subsystem

The Linux audit subsystem is enabled with various STIG-compliant rules. They are
covered below:

1. STIG-compliant rules:

   - `https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268165`

     NixOS must generate audit records when successful/unsuccessful attempts to
     delete security objects occur.

   - `https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268163`

     NixOS must generate audit records when successful/unsuccessful attempts to
     modify security objects occur.

     ```
     -a always,exit -F path=/run/current-system/sw/bin/chage -F perm=x -F auid>=1000 -F auid!=unset -k compliance-privileged-chage
     -a always,exit -F path=/run/current-system/sw/bin/chcon -F perm=x -F auid>=1000 -F auid!=unset -k compliance-perm-mod
     -a always,exit -F arch=b32 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid>=1000 -F auid!=-1 -k compliance-perm-mod
     -a always,exit -F arch=b32 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid=0 -k compliance-perm-mod
     -a always,exit -F arch=b64 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid>=1000 -F auid!=-1 -k compliance-perm-mod
     -a always,exit -F arch=b64 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid=0 -k compliance-perm-mod
     ```

   - `https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268164`

     NixOS must generate audit records when successful/unsuccessful attempts to
     delete privileges occur.

     ```
     -a always,exit -F path=/run/current-system/sw/bin/usermod -F perm=x -F auid>=1000 -F auid!=unset -k compliance-privileged-usermod
     ```

   - `https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268166`

     NixOS must generate audit records when concurrent logins to the same
     account occur from different sources.

     ```
     -a always,exit -F path=/var/log/lastlog -F perm=wa -F key=logins
     ```

   - `https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268167`

     NixOS must generate audit records for all account creations, modifications,
     disabling, and termination events.

     ```
     -a always,exit -F path=/etc/passwd -F perm=wa -F key=compliance-identity
     -a always,exit -F path=/etc/shadow -F perm=wa -F key=compliance-identity
     -a always,exit -F path=/etc/group -F perm=wa -F key=compliance-identity
     -a always,exit -F path=/etc/gshadow -F perm=wa -F key=compliance-identity
     -a always,exit -F path=/etc/sudoers -F perm=wa -F key=compliance-identity
     -a always,exit -F path=/etc/security/opasswd -F perm=wa -F key=compliance-identity
     ```

   - `https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268094`

     Successful/unsuccessful uses of the mount syscall in NixOS must generate an
     audit record.

     ```
     -a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k compliance-privileged-mount
     -a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k compliance-privileged-mount
     ```

   - `https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268091`

     NixOS must generate audit records for all usage of privileged commands.

     ```
     -a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k compliance-execpriv
     -a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -k compliance-execpriv
     -a always,exit -F arch=b32 -S execve -C gid!=egid -F egid=0 -k compliance-execpriv
     -a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -k compliance-execpriv
     ```

   - `https://www.stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268096`

     Successful/unsuccessful uses of the init_module, finit_module, and
     delete_module system calls in NixOS must generate an audit record.

     ```
     -a always,exit -F arch=b32 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k compliance-module-chng
     -a always,exit -F arch=b64 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k compliance-module-chng
     ```

2. Additional rules

   - log everytime a program is attempted to run

     ```
     -a exit,always -F arch=b64 -S execve -k rules-run
     ```

# Coredumps

Coredumps are disabled to prevent leaking sensitive information.

This is by disabling systemd coredumps, using PAM login limits, and using some
sysctl options.

# Emergency and Rescue

The emergency and rescue targets and services are disabled.

# Systemd Services

Upstream Nixpkgs already hardens several common service, especially
network-facing ones. Some services are additionally hardened with low-breakage
service options. These options are:

```nix
{
  ProtectClock = true;
  ProtectKernelTunables = true;
  ProtectKernelModules = true;
  ProtectKernelLogs = true;
  ProtectControlGroups = true;
  ProtectHome = "read-only";
  ProtectHostname = true;
  SystemCallArchitectures = "native";
  LockPersonality = true;
  NoNewPrivileges = true;
  PrivateDevices = true;
  PrivateTmp = true;
  RestrictRealtime = true;
  RestrictSUIDSGID = true;
}
```

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
group. Furthermore, only the root user is trusted by the store uri. This is
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
the world-readable Nix store.

# USBGuard

USBGuard is used to protect against rogue USB devices like BadUSB.

The policy is set to allow only patterns defined in the `usbs` list in the
variables file. All other devices are blocked. For example, to allow a keyboard:

```nix
usbs = [
  ''id 05f0:0217 serial "" name "Keychron K2" hash "a0ef07fceb6fb77698f79a44a450121m" parent-hash "69d19c1a5733a31e7e6d9530e6k434a6" via-port "1-2" with-interface { 03:01:01 03:01:02 } with-connect-type "hotplug"''
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
using SOPS.

> Laptop only

WPA3 (SAE / dragonfly) is used for wireless authentication on Laptop.

# DNS

Unbound DNS server hosted on Server is used as the default DNS server.

Cloudflare is used as the fallback server.

> Server only

The Unbound DNS server hosted on Server is hardened. The following options are
used:

1. disable ipv6

   ```
   prefer-ip6=no
   prefer-ip4=yes
   do-ip6=no
   do-ip4=yes
   ```

2. hide information

   ```
   hide-identity=yes
   hide-version=yes
   hide-trustanchor=yes
   hide-http-user-agent=yes
   ```

3. send minimum information to upstream servers

   ```
   qname-minimisation=yes
   qname-minimisation-strict=yes
   ```

4. harden against very small EDNS buffer sizes

   ```
   harden-short-bufsize=yes
   ```

5. harden against large queries

   ```
   harden-large-queries=yes
   ```

6. harden against out of zone rrsets, to avoid spoofing attempts

   ```
   harden-glue=yes
   ```

7. harden against unverified glue rrsets

   ```
   harden-unverified-glue=yes
   ```

8. harden against receiving dnssec-stripped data

   ```
   harden-dnssec-stripped=yes
   ```

9. harden against queries that fall under dnssec-signed nxdomain names

   ```
   harden-below-nxdomain=yes
   ```

10. harden the referral path by performing additional queries, intensive and
    experimental

    ```
    harden-referral-path=no
    ```

11. harden against downgrades when multiple algorithms are advertised

    ```
    harden-algo-downgrade=yes
    ```

12. harden against unknown records in the authority and additional sections

    ```
    harden-unknown-additional=yes
    ```

13. use the dnssec nsec chain

    ```
    aggressive-nsec=yes
    ```

14. use random bits in the query to foil spoof attempts

    ```
    use-caps-for-id=yes
    ```

# Firewall

The NixOS `networking.firewall` module is used, which uses the new `nf_tables`
backend. The userspace tool `nixos-firewall-tool` can be used for ad-hoc
changes.

By default, **NO** ports are open on **ANY** interface. Additionally, **NO**
interfaces are trusted, not even loopback.

ICMP ping requests are also disallowed.

> Server only

Ports are open on the server based on the enabled services. See
[Server Usage Documentation](./server/usage.md) which covers all ports.

Most ports are opened only to the loopback interface since services are
reverse-proxied via NGINX. For the few ports that are opened to LAN, the ports
are opened only to a select CIDR defined by the `network.range` variable in the
variables file. Since this value is a CIDR, it can be used to allow only
specific IP addresses. For example, by setting it to `10.0.0.100/31`, only
`10.0.0.100` and `10.0.0.101` are allowed.

# MAC Randomization

GNU MAC Changer is used to randomize the MAC address. Only the non-vendor bits
are randomized, since randomizing the entire MAC address may lead to extremely
uncommon MAC addresses which reduces anonymity.

# Secure Shell

> Server only

SSH is enabled on the Server. See
[Server Usage Documentation](./server/usage.md#ssh) for details about using a
non-default port, authorized keys, etc.

The SSH configuration is sufficiently hardened. The following options are set:

1. Only the main user and group is allowed.

2. Root login is disabled.

   ```
   PermitRootLogin no
   ```

3. Password authentication is disabled.

   ```
   PasswordAuthentication no
   ```

4. Only three authentication tries are allowed.

   ```
   MaxAuthTries 3
   ```

5. Only two concurrent session are allowed.

   ```
   MaxSessions 2
   ClientAliveCountMax 2
   ```

6. General hardening

   ```
   AllowTCPForwarding no
   TCPKeepAlive no
   AllowAgentForwarding no
   ```

# Fail2Ban

> Server only

Fail2Ban is used to limit brute force authentication attempts on SSH.

# I2P and Anonymity

> Laptop only

1. I2P

   The I2P network can be browsed using the
   [i2p-browser](./laptop/usage.md#i2p-browser) which uses the I2P HTTP Proxy
   hosted on Server.

2. Tor

   `oniux` can be used to run binaries in a Tor sandbox. Do not use `oniux` to
   run browsers, use the Tor Browser instead. The Tor Browser is not installed
   by default but can be used by installing it in an ad-hoc Nix shell.

3. Metadata Anonymization

   `mat2` can be used to remove any identifying metadata from files.

> Server only

The I2PD router is hosted on Server. The qBittorrent torrent client also uses
the I2P network via this router.

# Display Server

> Laptop only

The desktop is 100% wayland, with no X or Xwayland.

# Session Locking

> Laptop only

The session is locked using `swaylock` after 10 seconds of inactivity, and
suspended after further inactivity. This behaviour can be controlled using the
waybar [idle_inhibitor Module](./laptop/usage.md#idle_inhibitor-module).

# Bubblewrap

[Bubblewrap](https://github.com/containers/bubblewrap) is a low-level
unprivileged sandbox utility that is used by projects like
[Flatpak](https://flatpak.org/) and
[rpm-ostree](https://github.com/coreos/rpm-ostree/pull/209).

It provides several useful sandboxing features while maintaining a small focused
codebase to ensure a low overall attack surface. Furthermore, it is not a suid
binary. [Firejail](https://github.com/netblue30/firejail), for example, is
another sandboxing tool but uses suid binaries - which can act as a privilege
escalation hole. Bubblewrap does not have these issues.

Bubblewrap sandboxes can be created using the `bwrap(1)` command-line interface.
While this is available on both Laptop and Server roles, this flake uses
bubblewrap only for sandboxing browsers on the Laptop role. All the options used
are covered in the browsers section.

# xdg-dbus-proxy

> Laptop only

[xdg-dbus-proxy](https://github.com/flatpak/xdg-dbus-proxy) is a filtering proxy
for D-Bus connections. It is used in conjunction with bubblewrap because it lets
you selectively allow D-Bus connections. Without it, bubblewrap can only enable
D-Bus completely or disable it completely.

It is used on the Laptop role to let browsers use select D-Bus connections.

# Browsers

> Laptop only

Two hardened browsers are included. See
[Laptop Usage Documentation](./laptop/usage.md#browsers) for more information
about browser usage. This section covers the various hardening flags in the
browsers.

## Brave

1. Runs in a bubblewrap sandbox with xdg-dbus-proxy

   - Bubblewrap args:

     - Bind Nix Store as readonly

       ```
       --ro-bind /nix/store /nix/store
       ```

     - Allow using Wayland

       ```
       --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1" \
       ```

     - Bind fake passwd and group files as readonly

       ```bash
       users=$(mktemp -d)
       echo "${user}:x:1000:1000:${user}:/home/${user}:${pkgs.coreutils-full}/bin/false" > "$users/passwd"
       echo "${user}:x:1000:" > "$users/group"
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
       --tmpfs /home/${user}
       ```

     - Bind GTK files as readonly

       ```
       --ro-bind /home/${user}/.gtkrc-2.0 /home/${user}/.gtkrc-2.0
       --ro-bind /home/${user}/.config/gtk-3.0 /home/${user}/.config/gtk-3.0
       --ro-bind /home/${user}/.config/gtk-4.0 /home/${user}/.config/gtk-4.0
       --ro-bind /home/${user}/.icons /home/${user}/.icons
       --ro-bind /home/${user}/.Xresources /home/${user}/.Xresources
       --ro-bind /home/${user}/.local/share/fonts /home/${user}/.local/share/fonts
       --ro-bind /home/${user}/.local/share/icons /home/${user}/.local/share/icons
       --ro-bind /home/${user}/.local/share/themes /home/${user}/.local/share/themes
       --ro-bind /home/${user}/.config/dconf /home/${user}/.config/dconf
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

     - Bind /tmp to $XDG_RUNTIME_DIR/bubblewrap-brave-tmp so that MPRIS album
       art can be used

       ```bash
       brave_tmp="$XDG_RUNTIME_DIR/bubblewrap-brave-tmp"
       mkdir -p "$brave_tmp"
       ```

       ```
       --bind $brave_tmp /tmp
       ```

     - Bind Enterprise Policies as readonly

       ```
       --ro-bind /etc/static/brave /etc/static/brave
       --ro-bind /etc/brave /etc/brave
       ```

     - Bind configuration directory

       ```
       --bind /home/${user}/.config/BraveSoftware/Brave-Browser /home/${user}/.config/BraveSoftware/Brave-Browser
       ```

     - Bind local state as readonly

       ```
       --ro-bind "${state}/Local State" "/home/${user}/.config/BraveSoftware/Brave-Browser/Local State"
       ```

     - Bind downloads directory

       ```
       --bind /home/${user}/Downloads /home/${user}/Downloads
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
   [Chromium Enterprise Policies](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/enterprise/policies.md)
   and some
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

   - Use Post Quantum Key Cryptography
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

5. Extensions

   - Bitwarden (for use with selfhosted Vaultwarden)
   - uBlock Origin (further configured using policies)
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
       --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1" \
       ```

     - Bind fake passwd and group files as readonly

       ```bash
       users=$(mktemp -d)
       echo "${user}:x:1000:1000:${user}:/home/${user}:${pkgs.coreutils-full}/bin/false" > "$users/passwd"
       echo "${user}:x:1000:" > "$users/group"
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
       --tmpfs /home/${user}
       ```

     - Bind GTK files as readonly

       ```
       --ro-bind /home/${user}/.gtkrc-2.0 /home/${user}/.gtkrc-2.0
       --ro-bind /home/${user}/.config/gtk-3.0 /home/${user}/.config/gtk-3.0
       --ro-bind /home/${user}/.config/gtk-4.0 /home/${user}/.config/gtk-4.0
       --ro-bind /home/${user}/.icons /home/${user}/.icons
       --ro-bind /home/${user}/.Xresources /home/${user}/.Xresources
       --ro-bind /home/${user}/.local/share/fonts /home/${user}/.local/share/fonts
       --ro-bind /home/${user}/.local/share/icons /home/${user}/.local/share/icons
       --ro-bind /home/${user}/.local/share/themes /home/${user}/.local/share/themes
       --ro-bind /home/${user}/.config/dconf /home/${user}/.config/dconf
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

The SearXNG metasearch engine is hosted on Server. This preserves user privacy
while ensuring good quality results. See
[Server Usage Documentation](./server/usage.md#searxng) for information about
default search engines.

The Brave Browser uses SearXNG as the default search engine.

# Password Manager

The Vaultwarden password manager is hosted on Server. The Brave Browser uses the
Bitwarden extension to access the vault hosted on Server.

# Virtualisation and Containers

> Laptop only

See
[Virtualisation and Containers](./laptop/usage.md#virtualisation-and-containers).
