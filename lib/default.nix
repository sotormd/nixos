let
  colors = import ./colors.nix;
  conditionals = import ./conditionals.nix;
  filesystems = import ./filesystems.nix;
  homepage = import ./homepage.nix;
  services = import ./services.nix;
  wallpapers = import ./wallpapers.nix;
in
colors // conditionals // filesystems // homepage // services // wallpapers
