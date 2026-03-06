{
  imports = [
    # nix package manager configuration
    ../machines/common/nix

    # list of packages
    ./packages.nix
  ];

  time.timeZone = "UTC";

  environment.sessionVariables.EDITOR = "vi";

  # polkit for run0
  security.polkit.enable = true;
}
