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

      services.flatpak.enable = true;

      systemd.services.flatpak-repo = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        '';
      };

      system.stateVersion = "24.05";
    };
  };
in
{
  # enable nomad specialisations only if impermanence is enabled
  config = lib.mkIf config.vars.device.impermanence.enable {
    specialisation = lib.genAttrs desktops mkSpec;
  };
}
