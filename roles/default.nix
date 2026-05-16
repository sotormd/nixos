{ role, inputs }:

let
  roleConfig = import ./${role}/default.nix { inherit inputs; };
in
roleConfig
