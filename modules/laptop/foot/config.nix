{ config, pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "foot.ini";
    text = ''
      [colors]
      background=${config.colors.foot.bg}
      foreground=${config.colors.foot.fg}

      regular0=${config.colors.foot.regular0}
      regular1=${config.colors.foot.regular1}
      regular2=${config.colors.foot.regular2}
      regular3=${config.colors.foot.regular3}
      regular4=${config.colors.foot.regular4}
      regular5=${config.colors.foot.regular5}
      regular6=${config.colors.foot.regular6}
      regular7=${config.colors.foot.regular7}

      bright0=${config.colors.foot.bright0}
      bright1=${config.colors.foot.bright1}
      bright2=${config.colors.foot.bright2}
      bright3=${config.colors.foot.bright3}
      bright4=${config.colors.foot.bright4}
      bright5=${config.colors.foot.bright5}
      bright6=${config.colors.foot.bright6}
      bright7=${config.colors.foot.bright7}

      cursor=${config.colors.foot.cursor.bg} ${config.colors.foot.cursor.fg}

      [cursor]
      style=block

      [main]
      dpi-aware=yes
      font=${config.colors.fonts.monospace}:size=10
    '';
    destination = "/foot.ini";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "foot";
    paths = [ configuration ];
  };
}
