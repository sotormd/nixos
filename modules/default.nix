{
  modules = {

    # bash shell
    apps.bash = _: { imports = [ ./apps/bash ]; };

    # brave web browser
    apps.brave = _: { imports = [ ./apps/brave ]; };

    # btop status monitor
    apps.btop = _: { imports = [ ./apps/btop ]; };

    # automatic cpu speed & power optimizer
    apps.cpufreq = _: { imports = [ ./apps/cpufreq ]; };

    # development tools
    apps.dev = _: { imports = [ ./apps/dev ]; };

    # foot terminal emulator
    apps.foot = _: { imports = [ ./apps/foot ]; };

    # git version control system
    apps.git = _: { imports = [ ./apps/git ]; };

    # browse the i2p network
    apps.i2p-browser = _: { imports = [ ./apps/i2p-browser ]; };

    # inkscape vector graphics editor
    apps.inkscape = _: { imports = [ ./apps/inkscape ]; };

    # mousepad text editor
    apps.mousepad = _: { imports = [ ./apps/mousepad ]; };

    # mpv media player
    apps.mpv = _: { imports = [ ./apps/mpv ]; };

    # sandboxing with bubblewrap and xdg-dbus-proxy
    apps.sandbox = _: { imports = [ ./apps/sandbox ]; };

    # thunar file manager
    apps.thunar = _: { imports = [ ./apps/thunar ]; };

    # zathura pdf reader
    apps.zathura = _: { imports = [ ./apps/zathura ]; };

    # filesystems, external disks, luks, mounts
    boot.disks = _: { imports = [ ./boot/disks ]; };

    # binfmt emulated architectures
    boot.emulated = _: { imports = [ ./boot/emulated ]; };

    # host kernel modules and microcode
    boot.host = _: { imports = [ ./boot/host ]; };

    # kernel release, kernel parameters, sysctl options, module blacklists
    boot.kernel = _: { imports = [ ./boot/kernel ]; };

    # timezone, locales, keyboard layout
    boot.localization = _: { imports = [ ./boot/localization ]; };

    # graphene hardened malloc
    boot.malloc = _: { imports = [ ./boot/malloc ]; };

    # /persist directory
    boot.persist = _: { imports = [ ./boot/persist ]; };

    # quiet, non-verbose boot
    boot.quiet = _: { imports = [ ./boot/quiet ]; };

    # secureboot with lanzaboote
    boot.secureboot = _: { imports = [ ./boot/secureboot ]; };

    # systemd stage-1
    boot.stage-1 = _: { imports = [ ./boot/stage-1 ]; };

    # systemd-boot bootloader
    boot.systemd-boot = _: { imports = [ ./boot/systemd-boot ]; };

    # generic extlinux bootloader
    boot.uboot = _: { imports = [ ./boot/uboot ]; };

    # users and other nsswitch options
    boot.users = _: { imports = [ ./boot/users ]; };

    # filesystems for zfs on root, including impermanence rollback
    boot.zfsroot = _: { imports = [ ./boot/zfsroot ]; };

    # filesystems for bootstrap
    bootstrap.fs = _: { imports = [ ./bootstrap/fs ]; };

    # graphical settings bootstrap
    bootstrap.graphical = _: { imports = [ ./bootstrap/graphical ]; };

    # bootstrap remotely
    bootstrap.remote = _: { imports = [ ./bootstrap/remote ]; };

    # user settings for bootstrap
    bootstrap.user = _: { imports = [ ./bootstrap/user ]; };

    # bespoke `nixos` cli
    core.cli = _: { imports = [ ./core/cli ]; };

    # nix package manager
    core.nix = _: { imports = [ ./core/nix ]; };

    # base packages collection
    core.packages = _: { imports = [ ./core/packages ]; };

    # stateVersion
    core.state = _: { imports = [ ./core/state ]; };

    # gnome desktop
    desktop.gnome = _: { imports = [ ./desktop/gnome ]; };

    # nftables firewall
    network.firewall = _: { imports = [ ./network/firewall ]; };

    # networking, hostnames, dns, ssh aliases, ...
    network.host = _: { imports = [ ./network/host ]; };

    # hostapd
    network.hostapd = _: { imports = [ ./network/hostapd ]; };

    # gnu macchanger
    network.macchanger = _: { imports = [ ./network/macchanger ]; };

    # networkmanager
    network.networkmanager = _: { imports = [ ./network/networkmanager ]; };

    # build, sign and copy remote closures
    network.seed = _: { imports = [ ./network/seed ]; };

    # wired networking
    network.wired = _: { imports = [ ./network/wired ]; };

    # wireguard vpn
    network.wireguard = _: { imports = [ ./network/wireguard ]; };

    # wpa_supplicant wireless networking
    network.wireless = _: { imports = [ ./network/wireless ]; };

    # wpa3 dragonfly authentication
    network.wpa3 = _: { imports = [ ./network/wpa3 ]; };

    # linux audit subsystem
    services.auditd = _: { imports = [ ./services/auditd ]; };

    # distrobox containers
    services.distrobox = _: { imports = [ ./services/distrobox ]; };

    # dnscrypt-proxy for DoH
    services.dnscrypt = _: { imports = [ ./services/dnscrypt ]; };

    # systemd-journald
    services.journald = _: { imports = [ ./services/journald ]; };

    # libvirt with qemu/kvm and virt-manager
    services.libvirtd = _: { imports = [ ./services/libvirtd ]; };

    # audio with pipewire
    services.pipewire = _: { imports = [ ./services/pipewire ]; };

    # run0 privilege elevation
    services.run0 = _: { imports = [ ./services/run0 ]; };

    # openssh server
    services.sshd = _: { imports = [ ./services/sshd ]; };

    # systemd-timesyncd ntp
    services.timesyncd = _: { imports = [ ./services/timesyncd ]; };

    # usbguard daemon
    services.usbguard = _: { imports = [ ./services/usbguard ]; };

    # invisible internet protocol daemon
    svcvm.i2pd = _: { imports = [ ./svcvm/i2pd ]; };

    # nginx web server
    svcvm.nginx = _: { imports = [ ./svcvm/nginx ]; };

    # qbittorrent torrent client
    svcvm.qbt = _: { imports = [ ./svcvm/qbt ]; };

    # searxng metasearch engine
    svcvm.searxng = _: { imports = [ ./svcvm/searxng ]; };

    # vaultwarden password manager
    svcvm.vaultwarden = _: { imports = [ ./svcvm/vaultwarden ]; };

    # kiosk-style compositor
    sway.cage = _: { imports = [ ./sway/cage ]; };

    # dunst notification daemon
    sway.dunst = _: { imports = [ ./sway/dunst ]; };

    # gtk theming
    sway.gtk = _: { imports = [ ./sway/gtk ]; };

    # sway packages collection
    sway.packages = _: { imports = [ ./sway/packages ]; };

    # rofi launcher
    sway.rofi = _: { imports = [ ./sway/rofi ]; };

    # miscellaneous scripts for sway
    sway.scripts = _: { imports = [ ./sway/scripts ]; };

    # swaylock session locker
    sway.swaylock = _: { imports = [ ./sway/swaylock ]; };

    # sway wayland compositor
    sway.swaywm = _: { imports = [ ./sway/swaywm ]; };

    # waybar wayland panel
    sway.waybar = _: { imports = [ ./sway/waybar ]; };

    # schema for the variables system
    vars-schema = _: { imports = [ ./vars-schema ]; };

  };
}
