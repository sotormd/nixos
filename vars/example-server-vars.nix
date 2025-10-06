{
  # use this file to declare variables
  # this file will be stored in the world-readable /nix/store
  # for any sensitive data, use sops-nix instead
  # this file and ./secrets.yaml are not tracked by git

  ######################################
  # NIXOS CONFIGURATION FLAKE VARIABLES
  ######################################

  # directory where nixos configuration is stored
  nixosDirectory = "/nixos";

  # configuration role
  nixosRole = "server";

  ###################
  # DEVICE VARIABLES
  ###################

  # /etc/hostname
  device.hostName = "raspberry";

  # /etc/machine-id
  # passed as a boot parameter
  # do not change for consistent journald logs
  device.machineId = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";

  # partition partuuids
  # find them from /dev/disk/by-partuuid/...
  # assumes a specific configuration
  # see ../docs/server-setup.md
  device.root = "2178694e-02";

  # luks: encrypted luks devices
  # example usage:
  # device.luks = [
  #   {
  #       name = "ht02";
  #       uuid = "3f74d2e3-5a67-4b86-b2c3-842f39e45b7a";
  #       id = "usb-Samsung_192939485710293857281029-0:0";
  #       keyfile = "/root/keys/ht02";
  #       mount = "/mnt/ht02";
  #       fs = "xfs";
  #       hdparm = false;
  #   }
  # ];
  device.luks = [
    {
      name = "samsung";
      uuid = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";
      id = "usb-Samsung_192939485710293857281029-0:0";
      keyfile = "/root/keys/samsung";
      mount = "/mnt/samsung";
      fs = "xfs";
      hdparm = true;
    }
  ];

  #########################
  # USER ACCOUNT VARIABLES
  #########################

  # your username
  user.name = "Bar";

  # your email
  user.email = "Bar@domain.com";

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
  network.interface = "wlan0";

  # wireless network ssid
  network.ssid = "BarsNetwork";

  # network gateway
  network.gateway = "10.0.0.1";

  # local ip range
  network.range = "10.0.0.120/32";

  # static local device ip
  network.ip = "10.0.0.100";

  # duckdns domain
  network.duckdns.domain = "bars-server.duckdns.org";

  # ssh (LAN) port
  network.ssh.port = 42069;

  # ssh keys
  network.ssh.keys = [
    "ssh-ed25519 AAAAaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa Bar@domain.com"
  ];

  # unbound: validating recursive dns server
  network.unbound.enable = true;

  # nginx: web server
  network.nginx.enable = true;

  # searxng: metasearch engine
  # requires: nginx
  network.searxng.enable = true;

  # vaultwarden: password manager
  # requires: nginx
  network.vaultwarden.enable = true;

  # vaultwarden data directory
  network.vaultwarden.data = "/mnt/samsung/vw";

  # vaultwarden (loopback) port
  network.vaultwarden.port = 8222;

  # i2pd: invisible internet protocol daemon
  # requires: nginx
  network.i2pd.enable = true;

  # i2pd SAM (loopback) port
  network.i2pd.sam.port = 7656;

  # i2pd HTTP proxy (LAN) port
  network.i2pd.httpProxy.port = 42070;

  # i2pd SOCKS proxy (loopback) port
  network.i2pd.socksProxy.port = 4447;

  # i2pd webconsole (loopback) port
  network.i2pd.webconsole.port = 7070;

  # qbittorrent: bittorrent client
  # requires: i2pd, nginx
  network.qbt.enable = true;

  # qbittorrent data directory
  network.qbt.data = "/mnt/samsung/qbt";

  # qbittorrent (loopback) port
  network.qbt.port = 8080;

  # jellyfin: media server
  # requires: nginx
  network.jellyfin.enable = true;

  # jellyfin (loopback) port
  network.jellyfin.port = 8096;
}
