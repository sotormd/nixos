{ config, lib, ... }:

let
  inherit (config.vars.services) ssh;
in
lib.mkIf ssh.enable {

  # authorized keys
  users.users."${config.vars.user.name}".openssh.authorizedKeys.keys = lib.mkForce ssh.trusted-keys;

}
