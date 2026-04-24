{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];
  environment.sessionVariables.NIXOS_ROLE = "server";
}
