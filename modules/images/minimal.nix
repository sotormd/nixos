{ modulesPath, ... }:

{
  imports = [
    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # base configuration
    ./base.nix
  ];

  environment.sessionVariables.NIXOS_ROLE = "laptop";
  environment.sessionVariables.NIXOS_MOUNT = "/mnt";
}
