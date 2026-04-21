{
  role ? "machine-laptop",
  inputs,
}:

let
  roleConfig = import ./${role}/default.nix { inherit inputs; };
in
{
  system.stateVersion = "24.05";
}
// roleConfig
