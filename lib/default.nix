let
  conditionals = import ./conditionals.nix;
  filesystems = import ./filesystems.nix;
in
conditionals // filesystems
