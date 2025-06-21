{ vars, ... }:

{
  # enable libvirtd
  virtualisation.libvirtd.enable = true;

  # add user to libvirtd group
  users.users."${vars.user.name}".extraGroups = [ "libvirtd" ];
}
