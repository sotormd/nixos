{ config, lib, ... }:

let
  sshConfig = lib.concatStringsSep "\n\n" (
    lib.mapAttrsToList (name: cfg: ''
      Host ${name}
          HostName ${cfg.host}
          User ${cfg.user}
          Port ${toString cfg.port}
          IdentityFile ${cfg.keyfile}
    '') config.vars.user.sshAliases
  );
in
{
  config = {
    programs.ssh.extraConfig = sshConfig;
  };
}
