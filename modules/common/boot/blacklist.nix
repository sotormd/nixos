{ pkgs, ... }:

{
  # blacklist certain kernel modules
  boot.blacklistedKernelModules = [
    # datagram congestion control protocol
    # manages congestion without providing reliable data delivery
    # can blacklist unless using voice-over-IP
    "dccp"

    # stream control trasmission protocol
    # like tcp but with support for multiple streams
    # can blacklist unless involved in telecoms or signalling
    "sctp"

    # reliable datagram sockets
    # high performance clustered computing and inter-process communication
    # can blacklist unless running distributed systems
    "rds"

    # transparent inter-process communication
    # cluster-wide communication in systems like databases/clustered servers
    # can blacklist unless running clustered environments
    "tipc"

    # high-level data link control
    # serial communication and networking over physical links
    # can blacklist unless using specialized serial networking hardware
    "n-hdlc"

    # amateur radio X.25 protocol
    # amateur radio communication
    # can blacklist unless a radio operator
    "ax25"

    # network layer protocol used in AX.25
    "netrom"

    # X.25 protocol
    # packet-switched network protocol
    # can blacklist unless using legacy networking systems
    "x25"

    # amateur radio link layer
    # packet radio communication
    # can blacklist unless a radio operator
    "rose"

    # digital equipment corporation network
    # DEC network protocol for its proprietary systems
    # can blacklist unless using legacy DEC equipment
    "decnet"

    # Acorn Computers' networking protocol
    # proprietary network protocol developed by Acorn
    # can blacklist unless using legacy Acorn equipment
    "econet"

    # IEEE 802.15.4 protocol family
    # low-rate wireless personal area networks (LR-WPANs), mostly for IoT devices
    # can blacklist unless dealing with IoT
    "af_802154"

    # internetwork packet exchange
    # Novell protocol used in legacy networks
    # can blacklist unless using old Novell networks
    "ipx"

    # AppleTalk protocol
    # network protocol developed by Apple
    # can blacklist unless using legacy Mac systems
    "appletalk"

    # subnetwork access protocol
    # transmitting packets over different types of physical networks
    # can blacklist unless dealing with low-level networking
    "psnap"

    # IEEE 802.3 and 802.2
    # ethernet-based networking
    # standard for ethernet communication
    # can blacklist unless using ethernet (eg. only using wifi)
    "p8023"
    "p8022"

    # controller area network
    # communication in vehicles and industrial systems
    # can blacklist unless dealing with embedded/automotive systems
    "can"

    # asynchronous transfer mode
    # used in old telecommunications networks
    # can blacklist unless using legacy telecom equipment
    "atm"

    # rare filesystems
    # can blacklist if not using
    "cramfs"
    "freexvfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "squashfs"
    "udf"
    "overlay"
    "adfs"
    "affs"
    "bfs"
    "befs"
    "efs"
    "erofs"
    "exofs"
    "f2fs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"

    # network filesystems
    # can blacklist if not using
    "cifs"
    "nfs"
    "nfsv3"
    "nfsv4"
    "ksmbd"
    "gfs2"

    # virtual video driver
    # can blacklist unless testing video drivers
    "vivid"

    # IEEE 1394
    # high-speed interface for video cameras, external drives, etc
    # replacd by usb 3.0 and usb c
    # can blacklist unless using old firewire devices
    "firewire-core"

    # intel thunderbolt
    # high-speed data and power transfer
    # can blacklist unless using thunderbolt
    "thunderbolt"

    # bluetooth
    # can blacklist unless using bluetooth
    "bluetooth"
    "btusb"

    # usb video class devices
    # can blacklist unless using webcam
    "uvcvideo"

    # annoying PC speaker module
    # can blacklist unless deaf
    "pcspkr"
  ];

  boot.extraModprobeConfig = ''
    install dccp ${pkgs.coreutils}/bin/false
    install sctp ${pkgs.coreutils}/bin/false
    install rds ${pkgs.coreutils}/bin/false
    install tipc ${pkgs.coreutils}/bin/false
  '';
}
