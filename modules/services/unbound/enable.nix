{ config, lib, ... }:

let
  inherit (config.svcvm) vms unbound;
in
lib.mkIf (unbound.enable && !vms) {

  services.unbound.enable = true;

}
