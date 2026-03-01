{
  # only allow members of the wheel group to use the nix package manager
  nix.settings.allowed-users = [ "@wheel" ];
}
