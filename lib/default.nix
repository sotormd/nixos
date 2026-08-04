let
  colors = import ./colors.nix;
  filesystems = import ./filesystems.nix;
  homepage = import ./homepage.nix;
  services = import ./services.nix;
  wallpapers = import ./wallpapers.nix;
in
colors // filesystems // homepage // services // wallpapers
