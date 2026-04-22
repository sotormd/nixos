{

  # audio with pipewire
  audio = _: { imports = [ ./audio ]; };

  # linux audit subsystem
  audit = _: { imports = [ ./audit ]; };

  # automatic cpu speed & power optimizer
  auto-cpufreq = _: { imports = [ ./auto-cpufreq ]; };

  # bash shell
  bash = _: { imports = [ ./bash ]; };

  # bootstrap images
  bootstrap-image = _: { imports = [ ./bootstrap-image ]; };

  # bootstrap remotely
  bootstrap-remote = _: { imports = [ ./bootstrap-remote ]; };

  # brave web browser
  brave = _: { imports = [ ./brave ]; };

  # btop system resources monitor
  btop = _: { imports = [ ./btop ]; };

  # bespoke `nixos` cli
  cli = _: { imports = [ ./cli ]; };

  # disable coredumps
  coredumps = _: { imports = [ ./coredumps ]; };

  # development tools
  dev = _: { imports = [ ./dev ]; };

  # filesystems, external disks, luks, mounts
  disks = _: { imports = [ ./disks ]; };

  # distrobox containers
  distrobox = _: { imports = [ ./distrobox ]; };

  # dunst notification daemon
  dunst = _: { imports = [ ./dunst ]; };

  # disable emergency & rescue
  emergency-rescue = _: { imports = [ ./emergency-rescue ]; };

  # binfmt emulated architectures
  emulated = _: { imports = [ ./emulated ]; };

  # eww wm-agnostic widgets
  eww = _: { imports = [ ./eww ]; };

  # iptables-nft firewall
  firewall = _: { imports = [ ./firewall ]; };

  # foot terminal emulator
  foot = _: { imports = [ ./foot ]; };

  # git version control system
  git = _: { imports = [ ./git ]; };

  # graphene hardened malloc
  graphene-malloc = _: { imports = [ ./graphene-malloc ]; };

  # gtk theming
  gtk = _: { imports = [ ./gtk ]; };

  # hjem symlinks in $HOME
  hjem = _: { imports = [ ./hjem ]; };

  # hostname, hostid, machineid, issue
  host = _: { imports = [ ./host ]; };

  # browse the i2p network
  i2p-browser = _: { imports = [ ./i2p-browser ]; };

  # invisible internet protocol daemon
  i2pd = _: { imports = [ ./i2pd ]; };

  # inkscape vector graphics editor
  inkscape = _: { imports = [ ./inkscape ]; };

  # jellyfin media server
  jellyfin = _: { imports = [ ./jellyfin ]; };

  # hardware rng based on cpu timing jitter
  jitterentropy = _: { imports = [ ./jitterentropy ]; };

  # systemd-journald
  journald = _: { imports = [ ./journald ]; };

  # kernel release, kernel parameters, sysctl options, module blacklists
  kernel = _: { imports = [ ./kernel ]; };

  # libvirt with qemu/kvm and virt-manager
  libvirt = _: { imports = [ ./libvirt ]; };

  # timezone, locales, keyboard layout
  localization = _: { imports = [ ./localization ]; };

  # gnu macchanger
  macchanger = _: { imports = [ ./macchanger ]; };

  # mousepad text editor
  mousepad = _: { imports = [ ./mousepad ]; };

  # mpv media player
  mpv = _: { imports = [ ./mpv ]; };

  # nginx web server
  nginx = _: { imports = [ ./nginx ]; };

  # nix package manager
  nix = _: { imports = [ ./nix ]; };

  # base packages collection
  packages = _: { imports = [ ./packages ]; };

  # /persist directory
  persist = _: { imports = [ ./persist ]; };

  # plymouth flicker-free graphical boot
  plymouth = _: { imports = [ ./plymouth ]; };

  # qbittorrent torrent client
  qbt = _: { imports = [ ./qbt ]; };

  # quiet, non-verbose boot
  quietboot = _: { imports = [ ./quietboot ]; };

  # roaming mode
  roaming = _: { imports = [ ./roaming ]; };

  # rofi launcher
  rofi = _: { imports = [ ./rofi ]; };

  # run0 privilege elevation
  run0 = _: { imports = [ ./run0 ]; };

  # sandboxing with bubblewrap and xdg-dbus-proxy
  sandbox = _: { imports = [ ./sandbox ]; };

  # searxng metasearch engine
  searxng = _: { imports = [ ./searxng ]; };

  # secureboot with lanzaboote
  secureboot = _: { imports = [ ./secureboot ]; };

  # build, sign and copy remote closures
  seed = _: { imports = [ ./seed ]; };

  # sops-nix secrets management
  sops = _: { imports = [ ./sops ]; };

  # openssh client
  ssh = _: { imports = [ ./ssh ]; };

  # openssh server
  sshd = _: { imports = [ ./sshd ]; };

  # systemd stage-1
  stage-1 = _: { imports = [ ./stage-1 ]; };

  # stevenblack's host lists
  stevenblack = _: { imports = [ ./stevenblack ]; };

  # sway wayland compositor
  sway = _: { imports = [ ./sway ]; };

  # swaylock session locker
  swaylock = _: { imports = [ ./swaylock ]; };

  # systemd-boot bootloader
  systemd-boot = _: { imports = [ ./systemd-boot ]; };

  # thunar file manager
  thunar = _: { imports = [ ./thunar ]; };

  # systemd-timesyncd ntp
  timesyncd = _: { imports = [ ./timesyncd ]; };

  # generic extlinux bootloader
  uboot = _: { imports = [ ./uboot ]; };

  # unbound validating recursive dns server
  unbound = _: { imports = [ ./unbound ]; };

  # usbguard daemon
  usbguard = _: { imports = [ ./usbguard ]; };

  # users and other nsswitch options
  users = _: { imports = [ ./users ]; };

  # schema for the variables system
  vars-schema = _: { imports = [ ./vars-schema ]; };

  # vaultwarden password manager
  vaultwarden = _: { imports = [ ./vaultwarden ]; };

  # waybar wayland panel
  waybar = _: { imports = [ ./waybar ]; };

  # wpa_supplicant wireless networking
  wireless = _: { imports = [ ./wireless ]; };

  # wpa3 dragonfly authentication
  wpa3 = _: { imports = [ ./wpa3 ]; };

  # zathura pdf reader
  zathura = _: { imports = [ ./zathura ]; };

}
