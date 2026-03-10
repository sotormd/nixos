{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

    # base configuration
    ./base.nix

    # quiet boot
    ../machines/common/boot/quiet.nix
  ];

  environment.sessionVariables.NIXOS_ROLE = "server";

  users.users.root.initialHashedPassword = "";

  networking.networkmanager.enable = true;
}
