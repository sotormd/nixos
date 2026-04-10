{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.ssh.enable {
    services.openssh.enable = true;
  };
}
