{ config, lib, ... }:

let
  inherit (config.svcvm-guest) debug index;
in
lib.mkIf debug {

  microvm.vsock.cid = index;
  services.openssh = {
    enable = debug;
    startWhenNeeded = true;
    settings.PermitRootLogin = "yes";
  };
  systemd.sockets.sshd.socketConfig.ListenStream = [ "vsock::22" ];
  users.users.root = lib.mkIf debug { password = "toor"; };

}
