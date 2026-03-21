{ config, ... }:

{
  # enable libvirtd with swtpm support
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  # enable the virt-manager gui
  programs.virt-manager.enable = true;

  # add user to libvirtd group
  users.users."${config.vars.user.name}".extraGroups = [ "libvirtd" ];
}
