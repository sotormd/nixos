{ config, ... }:

{
  imports = [
    ./nginx.nix

    ./settings.nix
  ];

  services.i2pd.enable = config.vars.network.i2pd.enable;
}
