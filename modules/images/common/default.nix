{ lib, ... }:

{
  imports = [
    # nix package manager configuration
    ../../machines/common/nix

    # list of packages
    ./packages.nix
  ];

  time.timeZone = "UTC";

  environment.sessionVariables.EDITOR = "vi";

  users.users.nixos = {
    isNormalUser = true;

    # password: nixos
    initialHashedPassword = lib.mkForce "$y$j9T$EcXwZmlJcTbO2yjHu4xOy.$.M/ehO.13pAGk1rzJD4XAwpYzCay8una0iKIgZW7vc8";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  security.run0.wheelNeedsPassword = true;

  # polkit for run0
  security.polkit.enable = true;
}
