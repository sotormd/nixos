{ config, lib, ... }:

let
  inherit (config.vars.services) ssh;
in
{
  config = lib.mkIf ssh.enable {

    systemd.services.sshd = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };

  };
}
