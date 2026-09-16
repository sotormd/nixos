let
  colors = import ./colors.nix;
  filesystems = import ./filesystems.nix;
  homepage = import ./homepage.nix;
  services = import ./services.nix;
  wallpapers = import ./wallpapers.nix;
  wrappers = import ./wrappers.nix;
in
colors // filesystems // homepage // services // wallpapers // wrappers
