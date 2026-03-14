let
  conditionals = import ./conditionals.nix;
  filesystems = import ./filesystems.nix;
  systemd = import ./systemd.nix;
in
conditionals // filesystems // systemd
