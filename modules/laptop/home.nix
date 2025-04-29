{ inputs, home-manager, ... }:

{
  home-manager.extraSpecialArgs =
    let
      firefox-addons = inputs.firefox-addons;
    in
    {
      inherit firefox-addons;
    };
}
