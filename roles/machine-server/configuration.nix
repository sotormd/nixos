{
  config,
  pkgs,
  lib,
  modulesPath,
  legacyVars,
  ...
}:

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

  # nosuid,nodev
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
  microvm.vms = {
    unbound.restartIfChanged = false;
    nginx.restartIfChanged = false;
    searxng.restartIfChanged = false;
    i2pd.restartIfChanged = false;
    qbt.restartIfChanged = false;
  };

  # start microvms with enough delays
  # otherwise the pi will explode if all
  # microvms start concurrently
  systemd.services.start-microvms = {
    description = "Start MicroVMs";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
      "ip-link-up.service"
      "wpa_supplicant-${config.vars.wireless.interface}.service"
    ];
    after = [
      "network-online.target"
      "ip-link-up.service"
      "wpa_supplicant-${config.vars.wireless.interface}.service"
    ];
    serviceConfig =
      let
        inherit (config.vars.services)
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
  systemd.services.stop-microvms = {
    description = "Stop MicroVMs";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScriptBin "stop-microvms" ''
        systemctl stop microvm@unbound || true
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
    features = {
      secureboot.enable = lib.mkForce false;
    };
    modes = {
      roaming.enable = lib.mkForce false;
      nate.enable = lib.mkForce false;
      coffee.enable = lib.mkForce false;
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
        config.vars.services.vaultwarden.enable
        config.vars.services.searxng.enable
        config.vars.services.i2pd.enable
        config.vars.services.qbt.enable
      ];
      i2pdRequired = [
        config.vars.services.qbt.enable
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
        config.vars.modes.nate.enable
        config.vars.modes.coffee.enable
      ];
    in
    [
      {
        assertion = !(builtins.any (x: x) nginxRequired) || config.vars.services.nginx.enable;
        message = ''
          variables: nginx must be enabled if any dependent service is enabled
            - searxng
            - vaultwarden
            - i2pd
            - qbt
        '';
      }
      {
        assertion = !(builtins.any (x: x) i2pdRequired) || config.vars.services.i2pd.enable;
        message = ''
          variables: i2pd must be enabled if any dependent service is enabled
            - qbt
        '';
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
