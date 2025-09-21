{ vars, ... }:

{
  imports =
    if (vars.features.impermanence.enabled == true) then
      [
        ./home.nix

        ./root.nix
      ]
    else
      [ ];
}
