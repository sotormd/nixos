{
  # use this file to declare variables
  # this file will be stored in the world-readable /nix/store
  # for any sensitive data, use sops-nix instead
  # this file and ./secrets.yaml are not tracked by git

  ######################################
  # NIXOS CONFIGURATION FLAKE VARIABLES
  ######################################

  # directory where nixos configuration is stored
  nixosDirectory = "/persist/nixos";

  # configuration role
  nixosRole = "laptop";

  ###################
  # DEVICE VARIABLES
  ###################

  # /etc/hostname
  device.hostName = "framework-11";

  # /etc/machine-id
  # passed as a boot parameter
  # do not change for consistent journald logs
  device.machineId = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  # required for zfs
  device.hostId = "aaaaaaaa";

  # partition partuuids
  # find them from /dev/disk/by-partuuid/...
  # assumes a specific configuration
  # see ../docs/laptop.md
  device.boot = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
  device.swap = "bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
  device.root = "cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa";

  # mount: unencrypted mounts
  # example usage:
  #  device.mount = {
  #    "/mnt/location" = {
  #      device = "/dev/disk/by-partuuid/243fdae5-89df-4407-e6163e688f4d";
  #      fsType = "xfs";
  #      options = [ "defaults" ];
  #      neededForBoot = false;
  #    };
  #  };
  # this is directly translated to fileSystems."/mnt/location" = { ... };
  device.mount = { };

  # luks: encrypted luks devices
  # example usage:
  # device.luks = {
  #   ht02 = {
  #       uuid = "3f74d2e3-5a67-4b86-b2c3-842f39e45b7a";
  #       keyfile = "/root/keys/ht02";
  #       mount = "/mnt/ht02";
  #       fs = "xfs";
  #   };
  # };
  device.luks = { };

  # hdparm: stop aggressive head parking
  # example usage:
  # device.hdparm = [
  #   "usb-Samsung_192939485710293857281029-0:0"
  #   "usb-Hitachi_192939485710293857281029-0:0"
  # ];
  # pass list of disk ids (/dev/disk/by-id/...)
  device.hdparm = [ ];

  # secure boot: boot signed software
  # provided by the lanzaboote project
  # read docs/laptop.md before enabling
  device.secureboot.enable = true;

  # impermanence: erase your darlings
  # using zfs snapshots and bind mounts
  # read docs/laptop.md before enabling
  # requires: secureboot
  device.impermanence.enable = true;

  # plymouth: boot splash screen
  device.plymouth.enable = false;

  # auto-cpufreq: optimize cpu speed & power
  device.auto-cpufreq.enable = true;

  # powertop: power management tool
  device.powertop.enable = false;

  # tlp: optimize battery life
  device.tlp.enable = false;

  #########################
  # USER ACCOUNT VARIABLES
  #########################

  # your username
  user.name = "Bar";

  # your email
  user.email = "Bar@domain.com";

  # github ssh keyfile
  user.github.keyfile = "id_ed25519_github";

  #################
  # I18N VARIABLES
  #################

  # continent/city format timezone
  i18n.timeZone = "Europe/Zurich";

  # keyboard layout
  i18n.keyboard = "us";

  # locale
  i18n.locale = "en_US.UTF-8";

  #######################
  # NETWORKING VARIABLES
  #######################

  # wireless interface
  network.interface = "wlp1s0";

  # wireless network ssid
  network.ssid = "BarsNetwork";

  # network gateway
  network.gateway = "10.0.0.1";

  # static local device ip
  network.ip = "10.0.0.120";

  # use sae (dragonfly) authentication
  network.wpa3.enable = true;

  # use server features
  network.server.enable = true;

  # static local home server ip address
  network.server.ip = "10.0.0.100";

  # server domain
  network.server.domain = "bars-server.duckdns.org";

  # server ssh port
  network.server.ssh.port = 42069;

  # server ssh keyfile
  network.server.ssh.keyfile = "id_ed25519_server";

  # server i2p HTTP proxy port
  network.server.i2p.port = 42070;

  #############################
  # OUTPUT (DISPLAY) VARIABLES
  #############################

  # builtin laptop screen identifier (usually eDP-1)
  outputs.laptop = "eDP-1";

  # external monitor screen identifier (usually HDMI-A-1)
  outputs.monitor = "HDMI-A-1";

  # wallpaper
  outputs.wallpaper = "nord.mario";

  # lockscreen
  outputs.lockscreen = "nord.camera";
}
