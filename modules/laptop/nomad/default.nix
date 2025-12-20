{
  lib,
  pkgs,
  vars,
  ...
}:

let
  desktops = [
    "gnome"
  ];

  mkSpec = desktop: {
    inheritParentConfig = false;
    configuration = {
      imports = [
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

      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "nomad-${desktop}";

      networking = {
        wireless.enable = lib.mkForce false;
        networkmanager.enable = lib.mkForce true;
        nameservers = lib.mkForce [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };

      boot.kernel.sysctl."kernel.unprivileged_userns_clone" = lib.mkForce "1";

      users.users.${vars.user.name}.packages = [
        pkgs.librewolf
      ];

      system.stateVersion = "24.05";
    };
  };
in
{
  specialisation = lib.genAttrs desktops mkSpec;
}
