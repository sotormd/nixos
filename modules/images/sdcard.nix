{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

    # base configuration
    ./base.nix

    # quiet boot
    ../machines/common/boot/quiet.nix
  ];

  users.users.root.initialHashedPassword = "";

  users.users.nixos = {
    isNormalUser = true;
    initialHashedPassword = "";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  networking.networkmanager.enable = true;
}
