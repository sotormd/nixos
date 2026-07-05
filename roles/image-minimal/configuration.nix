{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  isoImage.edition = "minimal";

  environment.sessionVariables.NIXOS_MOUNT = "/mnt";
}
