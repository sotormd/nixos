{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  mkFontRules = pkg: [
    "L ${home}/.local/share/fonts/${pkg} - - - - ${pkgs.${pkg}}/share/fonts"
    "Z ${home}/.local/share/fonts/${pkg} - ${user} ${user} -"
  ];

  mkNerdRules = pkg: [
    "L ${home}/.local/share/fonts/nerdfonts/${pkg} - - - - ${pkgs.nerd-fonts.${pkg}}/share/fonts"
    "Z ${home}/.local/share/fonts/nerdfonts/${pkg} - ${user} ${user} -"
  ];

  allFontRules = lib.flatten [
    (map mkFontRules config.colors.fonts.packages)
    (map mkNerdRules config.colors.fonts.nerdfonts)
  ];
in
{
  systemd.tmpfiles.rules = [
    "d ${home} 0700 ${user} ${user} -"
    "d ${home}/.local 0700 ${user} ${user} -"
    "d ${home}/.local/share 0700 ${user} ${user} -"
    "d ${home}/.local/share/fonts 0700 ${user} ${user} -"
    "d ${home}/.local/share/fonts/nerdfonts 0700 ${user} ${user} -"
  ]
  ++ allFontRules;

  fonts.enableDefaultPackages = true;

  fonts.packages = lib.concatLists [
    (map (pkg: pkgs.${pkg}) config.colors.fonts.packages)
    (map (pkg: pkgs.nerd-fonts.${pkg}) config.colors.fonts.nerdfonts)
  ];
}
