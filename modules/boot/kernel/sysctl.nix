{ lib, ... }:

{
  # kernel sysctl options
  boot.kernel.sysctl = {
    # enable ASLR
    # randomises memory space for stack, heap, memory mappings and shared libraries
    "kernel.randomize_va_space" = lib.mkForce "2";

    # disable magic SysRq key
    "kernel.sysrq" = lib.mkForce "0";

    # restrict access to kernel pointers via /proc
    "kernel.kptr_restrict" = lib.mkForce "2";

    # only allow access to kernel log messages for privileged users
    "kernel.dmesg_restrict" = lib.mkForce "1";

    # disable unprivileged calls to berkeley packet filter
    "kernel.unprivileged_bpf_disabled" = lib.mkForce "1";

    # disable ability to load a new kernel while system is running
    "kernel.kexec_load_disabled" = lib.mkForce "1";

    # control use of performance events system by unprivileged users
    # >=2 disallows kernel profiling by unprivileged users
    "kernel.perf_event_paranoid" = lib.mkForce "3";

    # limits cpu time that can be accounted for performance events to 1%
    "kernel.perf_cpu_time_max_percent" = lib.mkForce "1";

    # limits sample rate for performance events to 1
    "kernel.perf_event_max_sample_rate" = lib.mkForce "1";

    # disable ptrace with yama LSM
    "kernel.yama.ptrace_scope" = lib.mkForce "3";

    # disable function tracing
    "kernel.ftrace_enabled" = lib.mkForce "0";

    # disable io_uring
    # https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
    "kernel.io_uring_disabled" = lib.mkForce "2";

    # prevent auto loading line disciplines for tty
    "dev.tty.ldisc_autoload" = lib.mkForce "0";

    # disable core dumps for setuid programs
    "fs.suid_dumpable" = lib.mkForce "0";

    # restricts creation of hard links to files owned by other users
    "fs.protected_hardlinks" = lib.mkForce "1";

    # restricts creation of symlinks to files owned by other users
    "fs.protected_symlinks" = lib.mkForce "1";

    # controls permissions for named pipes
    # only owned of the FIFO can write to it
    "fs.protected_fifos" = lib.mkForce "2";

    # restrict access to regular files by non-root users if the file is owned by another user
    "fs.protected_regular" = lib.mkForce "2";

    # disable the berkely packet filter JIT
    "net.core.bpf_jit_enable" = lib.mkForce "0";

    # enable JIT hardening techniques like constant blinding
    "net.core.bpf_jit_harden" = lib.mkForce "2";

    # protect against SYN flood attacks
    "net.ipv4.tcp_syncookies" = lib.mkForce "1";

    # protect against time-wait assassination by dropping RST packets
    "net.ipv4.tcp_rfc1337" = lib.mkForce "1";

    # enables source validation of received packets from all interfaces
    # protect against IP spoofing
    "net.ipv4.conf.all.rp_filter" = lib.mkForce "1";
    "net.ipv4.conf.default.rp_filter" = lib.mkForce "1";

    # disable ICMP redirect acceptance and sending
    # prevent MITM attacks
    "net.ipv4.conf.all.accept_redirects" = lib.mkForce "0";
    "net.ipv4.conf.default.accept_redirects" = lib.mkForce "0";
    "net.ipv4.conf.all.secure_redirects" = lib.mkForce "0";
    "net.ipv4.conf.default.secure_redirects" = lib.mkForce "0";
    "net.ipv4.conf.all.send_redirects" = lib.mkForce "0";
    "net.ipv4.conf.default.send_redirects" = lib.mkForce "0";
    "net.ipv6.conf.all.accept_redirects" = lib.mkForce "0";
    "net.ipv6.conf.default.accept_redirects" = lib.mkForce "0";

    # ignore all ICMP requests
    # prevent smurf attacks and clock fingerprinting
    "net.ipv4.icmp_echo_ignore_all" = lib.mkForce "1";
    "net.ipv4.icmp_echo_ignore_broadcasts" = lib.mkForce "1";

    # disable source routing
    # prevent MITM attacks
    "net.ipv4.conf.all.accept_source_route" = lib.mkForce "0";
    "net.ipv4.conf.default.accept_source_route" = lib.mkForce "0";
    "net.ipv6.conf.all.accept_source_route" = lib.mkForce "0";
    "net.ipv6.conf.default.accept_source_route" = lib.mkForce "0";

    # disable TCP SACK
    # commonly exploited and mostly unnecessary
    "net.ipv4.tcp_sack" = lib.mkForce "0";
    "net.ipv4.tcp_dsack" = lib.mkForce "0";
    "net.ipv4.tcp_fack" = lib.mkForce "0";

    # log martian packets
    "net.ipv4.conf.all.log_martians" = lib.mkForce "1";
    "net.ipv4.conf.default.log_martians" = lib.mkForce "1";

    # disable IPv6 router advertisements
    # prevent MITM attacks
    "net.ipv6.conf.all.accept_ra" = lib.mkForce "0";
    "net.ipv6.conf.default.accept_ra" = lib.mkForce "0";

    # generate a random IPv6 address every time
    # IPv6 addresses are tied to MAC address, making them unique for each device
    "net.ipv6.conf.all.use_tempaddr" = lib.mkForce "2";
    "net.ipv6.conf.default.use_tempaddr" = lib.mkForce "2";

    # tcp timestamps leak the system time
    # kernel attempts to mitigate this by adding random offsets
    # but that is not sufficient
    "net.ipv4.tcp_timestamps" = lib.mkForce "0";

    # disable the often-abused userfaultfd() syscall
    "vm.unprivileged_userfaultfd" = lib.mkForce "0";

    # increase bits of entropy used for mmap ASLR
    "vm.mmap_rnd_compat_bits" = lib.mkForce "16";
  };
}
