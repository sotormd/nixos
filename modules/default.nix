{

  # audio with pipewire
  audio = _: { imports = [ ./audio ]; };

  # linux audit subsystem
  audit = _: { imports = [ ./audit ]; };

  # automatic cpu speed & power optimizer
  auto-cpufreq = _: { imports = [ ./auto-cpufreq ]; };

  # bash shell
  bash = _: { imports = [ ./bash ]; };

  # brave web browser
  brave = _: { imports = [ ./brave ]; };

  # btop system resources monitor
  btop = _: { imports = [ ./btop ]; };

  # bespoke `nixos` cli
  cli = _: { imports = [ ./cli ]; };

  # development tools
  dev = _: { imports = [ ./dev ]; };

  # filesystems, external disks, luks, mounts
  disks = _: { imports = [ ./disks ]; };

  # distrobox containers
  distrobox = _: { imports = [ ./distrobox ]; };

  # dunst notification daemon
  dunst = _: { imports = [ ./dunst ]; };

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

  # hostname, hostid, issue
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

  # qbittorrent torrent client
  qbt = _: { imports = [ ./qbt ]; };

  # quiet, non-verbose boot
  quietboot = _: { imports = [ ./quietboot ]; };

  # rofi launcher
  rofi = _: { imports = [ ./rofi ]; };

  # searxng metasearch engine
  searxng = _: { imports = [ ./searxng ]; };

  # build, sign and copy remote closures
  seed = _: { imports = [ ./seed ]; };

  # sops-nix secrets management
  sops = _: { imports = [ ./sops ]; };

  # openssh server
  sshd = _: { imports = [ ./sshd ]; };

  # sway wayland compositor
  sway = _: { imports = [ ./sway ]; };

  # swaylock session locker
  swaylock = _: { imports = [ ./swaylock ]; };

  # thunar file manager
  thunar = _: { imports = [ ./thunar ]; };

  # unbound validating recursive dns server
  unbound = _: { imports = [ ./unbound ]; };

  # usbguard daemon
  usbguard = _: { imports = [ ./usbguard ]; };

  # vaultwarden password manager
  vaultwarden = _: { imports = [ ./vaultwarden ]; };

  # waybar wayland panel
  waybar = _: { imports = [ ./waybar ]; };

  # zathura pdf reader
  zathura = _: { imports = [ ./zathura ]; };

}
