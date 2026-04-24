{
  modules = {

    # bash shell
    apps.bash = _: { imports = [ ./apps/bash ]; };

    # brave web browser
    apps.brave = _: { imports = [ ./apps/brave ]; };

    # btop system resources monitor
    apps.btop = _: { imports = [ ./apps/btop ]; };

    # automatic cpu speed & power optimizer
    apps.cpufreq = _: { imports = [ ./apps/cpufreq ]; };

    # development tools
    apps.dev = _: { imports = [ ./apps/dev ]; };

    # distrobox containers
    apps.distrobox = _: { imports = [ ./apps/distrobox ]; };

    # file-roller archive manager
    apps.file-roller = _: { imports = [ ./apps/file-roller ]; };

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

    # neovim text editor
    apps.neovim = _: { imports = [ ./apps/neovim ]; };

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

    # hardware rng based on cpu timing jitter
    boot.jitterentropy = _: { imports = [ ./boot/jitterentropy ]; };

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

    # bootstrap images
    bootstrap.image = _: { imports = [ ./bootstrap/image ]; };

    # bootstrap remotely
    bootstrap.remote = _: { imports = [ ./bootstrap/remote ]; };

    # bespoke `nixos` cli
    core.cli = _: { imports = [ ./core/cli ]; };

    # nix package manager
    core.nix = _: { imports = [ ./core/nix ]; };

    # base packages collection
    core.packages = _: { imports = [ ./core/packages ]; };

    # iptables-nft firewall
    network.firewall = _: { imports = [ ./network/firewall ]; };

    # hostname, hostid, machineid, issue, ssh host aliases
    network.host = _: { imports = [ ./network/host ]; };

    # gnu macchanger
    network.macchanger = _: { imports = [ ./network/macchanger ]; };

    # roaming mode
    network.roaming = _: { imports = [ ./network/roaming ]; };

    # build, sign and copy remote closures
    network.seed = _: { imports = [ ./network/seed ]; };

    # stevenblack's host lists
    network.stevenblack = _: { imports = [ ./network/stevenblack ]; };

    # wpa_supplicant wireless networking
    network.wireless = _: { imports = [ ./network/wireless ]; };

    # wpa3 dragonfly authentication
    network.wpa3 = _: { imports = [ ./network/wpa3 ]; };

    # linux audit subsystem
    services.auditd = _: { imports = [ ./services/auditd ]; };

    # invisible internet protocol daemon
    services.i2pd = _: { imports = [ ./services/i2pd ]; };

    # jellyfin media server
    services.jellyfin = _: { imports = [ ./services/jellyfin ]; };

    # systemd-journald
    services.journald = _: { imports = [ ./services/journald ]; };

    # libvirt with qemu/kvm and virt-manager
    services.libvirtd = _: { imports = [ ./services/libvirtd ]; };

    # nginx web server
    services.nginx = _: { imports = [ ./services/nginx ]; };

    # audio with pipewire
    services.pipewire = _: { imports = [ ./services/pipewire ]; };

    # qbittorrent torrent client
    services.qbt = _: { imports = [ ./services/qbt ]; };

    # run0 privilege elevation
    services.run0 = _: { imports = [ ./services/run0 ]; };

    # searxng metasearch engine
    services.searxng = _: { imports = [ ./services/searxng ]; };

    # openssh server
    services.sshd = _: { imports = [ ./services/sshd ]; };

    # systemd-timesyncd ntp
    services.timesyncd = _: { imports = [ ./services/timesyncd ]; };

    # unbound validating recursive dns server
    services.unbound = _: { imports = [ ./services/unbound ]; };

    # usbguard daemon
    services.usbguard = _: { imports = [ ./services/usbguard ]; };

    # vaultwarden password manager
    services.vaultwarden = _: { imports = [ ./services/vaultwarden ]; };

    # dunst notification daemon
    sway.dunst = _: { imports = [ ./sway/dunst ]; };

    # eww wm-agnostic widgets
    sway.eww = _: { imports = [ ./sway/eww ]; };

    # gtk theming
    sway.gtk = _: { imports = [ ./sway/gtk ]; };

    # sway packages collection
    sway.packages = _: { imports = [ ./sway/packages ]; };

    # rofi launcher
    sway.rofi = _: { imports = [ ./sway/rofi ]; };

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
