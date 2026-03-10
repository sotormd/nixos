{ config, ... }:

{
  imports = [
    ./eepsite.nix

    ./nginx.nix

    ./settings.nix
  ];

  services.i2pd.enable = config.vars.services.i2pd.enable;
}
