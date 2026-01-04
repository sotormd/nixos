let
  conditionals = import ./conditionals.nix;
  impermanence = import ./impermanence.nix;
in
conditionals // impermanence
