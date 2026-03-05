{ lib, ... }:

{
  # only allow members of the wheel group to use the nix package manager
  nix.settings.allowed-users = [ "@wheel" ];

  # only trust the root user
  nix.settings.trusted-users = lib.mkForce [ "root" ];
}
