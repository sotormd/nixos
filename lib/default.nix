let
  conditionals = import ./conditionals.nix;
  filesystems = import ./filesystems.nix;
  services = import ./services.nix;
in
conditionals // filesystems // services
