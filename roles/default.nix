{
  role,
  inputs,
  legacyVars ? { },
}:

let
  roleConfig = import ./${role}/default.nix { inherit inputs legacyVars; };
in
roleConfig // { system.stateVersion = "24.05"; }
