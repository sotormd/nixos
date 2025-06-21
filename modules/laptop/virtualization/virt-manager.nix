{ home-manager, vars, ... }:

{
  # enable the virt-manager gui
  programs.virt-manager.enable = true;

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
