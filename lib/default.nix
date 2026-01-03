{ lib, ... }:

let
  conditionals = import ./conditionals.nix;
  impermanence = import ./impermanence.nix { inherit lib; };
in
conditionals // impermanence
