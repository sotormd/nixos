{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  isoImage.edition = "minimal";

  environment = {
    sessionVariables = {
      NIXOS_ROLE = "laptop";
      NIXOS_MOUNT = "/mnt";
    };
  };
}
