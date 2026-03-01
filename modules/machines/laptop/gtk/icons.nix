{ config, pkgs, ... }:

{
  hjem.users.${config.vars.user.name}.files = {
    ".local/share/icons/${config.colors.gtk.icons.name}".source = "${
      pkgs.${config.colors.gtk.icons.package}
    }/share/icons/${config.colors.gtk.icons.name}";
  };
}
