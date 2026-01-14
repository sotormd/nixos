{
  config,
  lib,
  pkgs,
  ...
}:

{
  hjem.users.${config.vars.user.name}.files =
    { }
    // builtins.listToAttrs (
      map (pkg: {
        name = ".local/share/fonts/${pkg}";
        value.source = "${pkgs.${pkg}}/share/fonts";
      }) config.colors.fonts.packages
    )
    // builtins.listToAttrs (
      map (pkg: {
        name = ".local/share/fonts/nerdfonts/${pkg}";
        value.source = "${pkgs.nerd-fonts.${pkg}}/share/fonts";
      }) config.colors.fonts.nerdfonts
    );

  fonts.enableDefaultPackages = true;

  fonts.packages = lib.concatLists [
    (map (pkg: pkgs.${pkg}) config.colors.fonts.packages)
    (map (pkg: pkgs.nerd-fonts.${pkg}) config.colors.fonts.nerdfonts)
  ];
}
