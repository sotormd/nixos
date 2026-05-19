{ config, lib, ... }:

let
  inherit (config.vars.services) ssh;
in
lib.mkIf ssh.enable {

  services.openssh.enable = true;

}
