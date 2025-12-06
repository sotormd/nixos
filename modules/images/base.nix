{
  imports = [
    # nix package manager configuration
    ../common/nix

    # list of packages
    ./packages.nix
  ];

  time.timeZone = "UTC";

  environment.sessionVariables.EDITOR = "vi";

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
