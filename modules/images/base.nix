{
  imports = [
    # nix package manager configuration
    ../machines/common/nix

    # list of packages
    ./packages.nix
  ];

  time.timeZone = "UTC";

  environment.sessionVariables.EDITOR = "vi";

  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "nixos";
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
