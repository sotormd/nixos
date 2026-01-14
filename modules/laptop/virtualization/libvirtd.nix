{ config, ... }:

{
  # enable libvirtd
  virtualisation.libvirtd.enable = true;

  # add user to libvirtd group
  users.users."${config.vars.user.name}".extraGroups = [ "libvirtd" ];
}
