{
  role ? "laptop",
}:

let
  roleConfig = import ./${role}.nix;
in
{
  system.stateVersion = "24.05";
}
// roleConfig
