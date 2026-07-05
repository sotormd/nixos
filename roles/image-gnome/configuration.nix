{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix" ];

  isoImage.edition = "gnome";

  environment.sessionVariables.NIXOS_MOUNT = "/mnt";
}
