{ pkgs, modulesPath, ... }:

{
  imports = [
    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # nix package manager configuration
    ../../modules/common/nix

    # list of packages
    ./packages.nix
  ];

  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [ nerd-fonts.fira-code ];

  environment.sessionVariables.EDITOR = "vi";

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
