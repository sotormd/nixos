{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gparted ];
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };
}
