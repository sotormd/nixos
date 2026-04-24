{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  mkFontRule = pkg: "L ${home}/.local/share/fonts/${pkg} - - - - ${pkgs.${pkg}}/share/fonts";

  mkNerdRule =
    pkg: "L ${home}/.local/share/fonts/nerdfonts/${pkg} - - - - ${pkgs.nerd-fonts.${pkg}}/share/fonts";
in
{
  systemd.tmpfiles.rules = [
    "d ${home}/.local 0700 ${user} ${user} -"
    "d ${home}/.local/share 0700 ${user} ${user} -"
    "d ${home}/.local/share/fonts 0700 ${user} ${user} -"
    "d ${home}/.local/share/fonts/nerdfonts 0700 ${user} ${user} -"
  ]
  ++ map mkFontRule config.colors.fonts.packages
  ++ map mkNerdRule config.colors.fonts.nerdfonts;

  fonts.enableDefaultPackages = true;

  fonts.packages = lib.concatLists [
    (map (pkg: pkgs.${pkg}) config.colors.fonts.packages)
    (map (pkg: pkgs.nerd-fonts.${pkg}) config.colors.fonts.nerdfonts)
  ];
}
