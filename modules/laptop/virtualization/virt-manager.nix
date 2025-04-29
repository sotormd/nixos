{ home-manager, vars, ... }:

{
  # enable libvirtd
  virtualisation.libvirtd.enable = true;

  # enable the virt-manager gui
  programs.virt-manager.enable = true;

  # add user to libvirtd group
  users.users."${vars.user.name}".extraGroups = [ "libvirtd" ];

  home-manager.users."${vars.user.name}" = {
    # add the qemu connection to virt-manager
    dconf = {
      enable = true;
      settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };
  };
}
