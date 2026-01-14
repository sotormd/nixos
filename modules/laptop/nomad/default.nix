{
  config,
  lib,
  pkgs,
  ...
}:

let
  desktops = [
    "gnome"
  ];

  mkSpec = desktop: {
    inheritParentConfig = false;
    configuration = {

      # everything needed for a clean, base system
      imports = [
        ../../../vars-schema/common.nix
        ../../../vars-schema/laptop.nix
        ../../common
        ../audio
        ../boot
        ../impermanence
        ../network
        ../sops
        ../ssh
        ../users
        ../virtualization
        ./${desktop}.nix
      ];

      vars.nixosRole = lib.mkForce "nomad";

      networking = {
        wireless.enable = lib.mkForce false;
        networkmanager.enable = lib.mkForce true;
        nameservers = lib.mkForce [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };

      boot.kernel.sysctl."kernel.unprivileged_userns_clone" = lib.mkForce "1";

      users.users.${config.vars.user.name}.packages = [
        pkgs.librewolf
      ];

      system.stateVersion = "24.05";
    };
  };
in
{
  specialisation = lib.genAttrs desktops mkSpec;
}
