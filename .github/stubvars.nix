{
  device = {
    hostName = "stub";
    machineId = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    hostId = "aaaaaaaa";
  };

  partitions = {
    boot = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
    swap = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";
    root = "cccccccc-cccc-cccc-cccc-cccccccccccc";
  };

  filesystem = {
    luks = {
      stub = {
        uuid = "dddddddd-dddd-dddd-dddd-dddddddddddd";
        keyfile = "/persist/keys/stub";
      };
    };
    mount = {
      raw = { };
      harden = { };
      data = {
        "/mnt/stub" = {
          device = "/dev/mapper/stub";
          fsType = "xfs";
          options = [ "defaults" ];
        };
        "/persist/root/srv/torrents" = {
          device = "/mnt/stub/server/srv/torrents";
          fsType = "none";
          options = [ "bind" ];
        };
      };
      immutable = { };
      static = { };
    };
  };

  usbs = [
    ''id aaaa:aaaa serial "" name "STUB" hash "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" parent-hash "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" via-port "1-2" with-interface { 03:01:01 03:01:02 } with-connect-type "hotplug"''
  ];

  user = {
    name = "stub";
    git = {
      name = "stub";
      email = "stub@stub";
      signing-key = "/home/stub/.ssh/id_ed25519_STUB.pub";
      allowed-signers = "/home/stub/.ssh/git_allowed_signers";
    };
    sshAliases = {
      github = {
        user = "git";
        host = "github.com";
        port = 22;
        keyfile = "/home/stub/.ssh/id_ed25519_STUB";
      };
    };
  };

  localization = {
    timeZone = "UTC";
    keyboard = "us";
    locale = "en_US.UTF-8";
  };

  wireless = {
    interface = "wlp1s0";
    ssid = "net";
    gateway = "10.0.0.1";
    address = "10.0.0.2";
    resolver = "10.0.0.3";
  };

  displays = {
    outputs = {
      laptop = {
        identifier = "eDP-1";
        resolution = "1920x1200";
        refresh = "60Hz";
        position = "0 0";
      };
      monitor = {
        identifier = "HDMI-A-1";
        resolution = "1920x1080";
        refresh = "60Hz";
        position = "1920 0";
      };
    };
    primary = "monitor";
  };

  features = {
    secureboot.enable = true;
    impermanence.enable = true;
  };

  modes = {
    roaming.enable = true;
    nate.enable = true;
    coffee.enable = true;
  };

  selfhosted = {
    searxng = {
      enable = true;
      domain = "stub.duckdns.org";
    };
    vaultwarden = {
      enable = true;
      domain = "stub.duckdns.org";
    };
    i2pd = {
      enable = true;
      address = "10.0.0.3";
      domain = "stub.duckdns.org";
    };
    qbt = {
      enable = true;
      domain = "stub.duckdns.org";
    };
    jellyfin = {
      enable = true;
      domain = "stub.duckdns.org";
    };
  };

  services = {
    ssh = {
      enable = true;
      allow = "10.0.0.2/32";
      port = 22;
      trusted-keys = [
        "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA stub@stub"
      ];
    };
    unbound = {
      enable = true;
      allow = "10.0.0.2/32";
    };
    nginx = {
      enable = true;
      email = "stub@stub";
      domain = "example.duckdns.org";
      allow = "10.0.0.2/32";
    };
    searxng = {
      enable = true;
      allow = "10.0.0.2/32";
    };
    vaultwarden = {
      enable = true;
      allow = "10.0.0.2/32";
    };
    i2pd = {
      enable = true;
      allow = "10.0.0.2/32";
    };
    qbt = {
      enable = true;
      allow = "10.0.0.2/32";
    };
    jellyfin = {
      enable = true;
      allow = "10.0.0.2/32";
    };
  };

  seed = {
    enable = true;
    trusted-keys = [ "stub:AUhj6iuXNZepgij+Rsuw7w6wzx8nFNJnmkv1JaMUL9o=" ];
  };
}
