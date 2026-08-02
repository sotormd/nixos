{
  config,
  pkgs,
  lib,
  vars,
  ...
}:

let
  inherit (config.vars) services;
  svcvmsNeeded =
    services.unbound.enable
    || services.nginx.enable
    || services.searxng.enable
    || services.vaultwarden.enable
    || services.i2pd.enable
    || services.qbt.enable;
in
{
  # server needs to forward packets
  boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkForce "1";

  # do not suspend when lid is closed
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  # start svcvms
  systemd.services.start-svcvms = {
    enable = svcvmsNeeded;
    description = "Start svcvm Service Virtual Machines";
    wantedBy = [ "svcvm.target" ];
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
        step = "10";
      in
      {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.writeShellScriptBin "start-svcvms-pre" ''
          until ${pkgs.iputils}/bin/ping -c1 1.1.1.1 >/dev/null 2>&1; do
            sleep 2
          done
        ''}/bin/start-svcvms-pre";
        ExecStart = "${pkgs.writeShellScriptBin "start-svcvms" ''
          ${
            (lib.optionalString unbound.enable ''
              sleep ${step}
              echo "starting unbound"
              systemctl start svcvm@unbound
            '')
          }
          ${
            (lib.optionalString searxng.enable ''
              sleep ${step}
              echo "starting searxng"
              systemctl start svcvm@searxng
            '')
          }
          ${
            (lib.optionalString vaultwarden.enable ''
              sleep ${step}
              echo "starting vaultwarden"
              systemctl start svcvm@vaultwarden
            '')
          }
          ${
            (lib.optionalString i2pd.enable ''
              sleep ${step}
              echo "starting i2pd"
              systemctl start svcvm@i2pd
            '')
          }
          ${
            (lib.optionalString qbt.enable ''
              sleep ${step}
              echo "starting qbt"
              systemctl start svcvm@qbt
            '')
          }
          ${
            (lib.optionalString nginx.enable ''
              sleep ${step}
              echo "starting nginx"
              systemctl start svcvm@nginx
            '')
          }
        ''}/bin/start-svcvms";
      };
  };

  # stop svcvms
  # dont stop unbound
  systemd.services.stop-svcvms = {
    enable = svcvmsNeeded;
    description = "Stop svcvm Service Virtual Machines";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScriptBin "stop-svcvms" ''
        # systemctl stop svcvm@unbound || true
        systemctl stop svcvm@searxng || true
        systemctl stop svcvm@vaultwarden || true
        systemctl stop svcvm@i2pd || true
        systemctl stop svcvm@qbt || true
        systemctl stop svcvm@nginx || true
      ''}/bin/stop-svcvms";
    };
  };

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "server";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate vars {
    user = {
      git = lib.mkForce { };
      sshAliases = lib.mkForce { };
    };
    wireguard = {
      forwarding = lib.mkForce true;
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
