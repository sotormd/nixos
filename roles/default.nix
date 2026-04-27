{ role, inputs }:

let
  roleConfig = import ./${role}/default.nix { inherit inputs; };
in
roleConfig // { system.stateVersion = import ../state.nix; }
