{
  config,
  pkgs,
  lib,
  modulesPath,
  legacyVars,
  ...
}:

let
  inherit (config.vars) services;
  microvmsNeeded =
    services.unbound.enable
    || services.nginx.enable
    || services.searxng.enable
    || services.vaultwarden.enable
    || services.i2pd.enable
    || services.qbt.enable;
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
  ];

  # filesystems
  fileSystems = {

    # root partition
    "/" = {
      device = "/dev/disk/by-partuuid/${config.vars.partitions.root}";
      fsType = "ext4";
    };

  }

  # nosuid,nodev
  // lib.mkSelfHarden [
    "/persist"
  ]

  # nosuid,nodev,noexec
  // lib.mkSelfData [
    "/persist/sops-nix"
    "/tmp"
  ];

  # so that the raspberry pi doesn't explode
  nix.settings.max-jobs = 1;
  nix.settings.cores = 1;

  # kernel sysctl options
  boot.kernel.sysctl = {
    # increase bits of entropy used for mmap ASLR
    "vm.mmap_rnd_bits" = lib.mkForce "33";
    # server needs to forward packets
    "net.ipv4.ip_forward" = lib.mkForce "1";
  };

  # do not autostart microvms
  microvm.autostart = lib.mkForce [ ];

  # start microvms with enough delays
  # otherwise the pi will explode if all
  # microvms start concurrently
  systemd.services.start-microvms = {
    enable = microvmsNeeded;
    description = "Start MicroVMs";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
      "wpa_supplicant-${config.vars.wireless.interface}.service"
    ];
    after = [
      "network-online.target"
      "wpa_supplicant-${config.vars.wireless.interface}.service"
    ];
    serviceConfig =
      let
        inherit (services)
          unbound
          nginx
          searxng
          vaultwarden
          i2pd
          qbt
          ;
        step = "180";
      in
      {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.writeShellScriptBin "start-microvms-pre" ''
          until ${pkgs.iputils}/bin/ping -c1 1.1.1.1 >/dev/null 2>&1; do
            sleep 2
          done
        ''}/bin/start-microvms-pre";
        ExecStart = "${pkgs.writeShellScriptBin "start-microvms" ''
          ${
            (lib.optionalString unbound.enable ''
              sleep ${step}
              echo "starting unbound"
              systemctl start microvm@unbound
            '')
          }
          ${
            (lib.optionalString searxng.enable ''
              sleep ${step}
              echo "starting searxng"
              systemctl start microvm@searxng
            '')
          }
          ${
            (lib.optionalString vaultwarden.enable ''
              sleep ${step}
              echo "starting vaultwarden"
              systemctl start microvm@vaultwarden
            '')
          }
          ${
            (lib.optionalString i2pd.enable ''
              sleep ${step}
              echo "starting i2pd"
              systemctl start microvm@i2pd
            '')
          }
          ${
            (lib.optionalString qbt.enable ''
              sleep ${step}
              echo "starting qbt"
              systemctl start microvm@qbt
            '')
          }
          ${
            (lib.optionalString nginx.enable ''
              sleep ${step}
              echo "starting nginx"
              systemctl start microvm@nginx
            '')
          }
        ''}/bin/start-microvms";
      };
  };

  # stop microvms
  # probably need this before
  # a flake re-eval or rebuild
  # so that it doesn't explode
  #
  # dont stop unbound
  systemd.services.stop-microvms = {
    enable = microvmsNeeded;
    description = "Stop MicroVMs";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScriptBin "stop-microvms" ''
        # systemctl stop microvm@unbound || true
        systemctl stop microvm@searxng || true
        systemctl stop microvm@vaultwarden || true
        systemctl stop microvm@i2pd || true
        systemctl stop microvm@qbt || true
        systemctl stop microvm@nginx || true
      ''}/bin/stop-microvms";
    };
  };

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "server";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate legacyVars {
    user = {
      git = lib.mkForce { };
      sshAliases = lib.mkForce { };
    };
    wireguard = {
      forwarding = lib.mkForce true;
    };
    features = {
      secureboot.enable = lib.mkForce false;
    };
    modes = {
      roaming.enable = lib.mkForce false;
      gnome.enable = lib.mkForce false;
    };
    selfhosted = {
      searxng.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      i2pd.enable = lib.mkForce false;
      qbt.enable = lib.mkForce false;
    };
  };

  # ensure no tomfoolery
  assertions =
    let
      nginxRequired = [
        services.vaultwarden.enable
        services.searxng.enable
        services.i2pd.enable
        services.qbt.enable
      ];
      i2pdRequired = [
        services.qbt.enable
      ];
      featuresDisabled = [
        config.vars.features.secureboot.enable
      ];
      selfhostedDisabled = [
        config.vars.selfhosted.searxng.enable
        config.vars.selfhosted.vaultwarden.enable
        config.vars.selfhosted.i2pd.enable
        config.vars.selfhosted.qbt.enable
      ];
      modesDisabled = [
        config.vars.modes.roaming.enable
        config.vars.modes.gnome.enable
      ];
    in
    [
      {
        assertion = !(builtins.any (x: x) nginxRequired) || services.nginx.enable;
        message = ''
          variables: nginx must be enabled if any dependent service is enabled
            - searxng
            - vaultwarden
            - i2pd
            - qbt
        '';
      }
      {
        assertion = !(builtins.any (x: x) i2pdRequired) || services.i2pd.enable;
        message = ''
          variables: i2pd must be enabled if any dependent service is enabled
            - qbt
        '';
      }
      {
        assertion = config.vars.wireguard.forwarding;
        message = "variables: vars.wireguard.forwarding needs to be true";
      }
      {
        assertion = builtins.all (x: !x) featuresDisabled;
        message = "variables: unsupported vars.features.* are enabled";
      }
      {
        assertion = builtins.all (x: !x) selfhostedDisabled;
        message = "variables: unsupported vars.selfhosted.* are enabled";
      }
      {
        assertion = builtins.all (x: !x) modesDisabled;
        message = "variables: unsupported vars.modes.* are enabled";
      }
      {
        assertion = config.vars.user.sshAliases == { };
        message = "variables: vars.user.git is not supported";
      }
      {
        assertion = config.vars.user.sshAliases == { };
        message = "variables: vars.user.sshAliases is not supported";
      }
    ];
}
