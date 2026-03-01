{ config, pkgs, ... }:

{
  # enable wireplumber
  services.pipewire.wireplumber.enable = true;

  # wpctl
  users.users.${config.vars.user.name}.packages = [ pkgs.wireplumber ];
}
