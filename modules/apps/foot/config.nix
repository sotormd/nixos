{ writeTextFile, colors, ... }:

let
  configuration = writeTextFile {
    name = "foot.ini";
    text = ''
      [colors-dark]
      background=${colors.foot.bg}
      foreground=${colors.foot.fg}

      regular0=${colors.foot.regular0}
      regular1=${colors.foot.regular1}
      regular2=${colors.foot.regular2}
      regular3=${colors.foot.regular3}
      regular4=${colors.foot.regular4}
      regular5=${colors.foot.regular5}
      regular6=${colors.foot.regular6}
      regular7=${colors.foot.regular7}

      bright0=${colors.foot.bright0}
      bright1=${colors.foot.bright1}
      bright2=${colors.foot.bright2}
      bright3=${colors.foot.bright3}
      bright4=${colors.foot.bright4}
      bright5=${colors.foot.bright5}
      bright6=${colors.foot.bright6}
      bright7=${colors.foot.bright7}

      cursor=${colors.foot.cursor.bg} ${colors.foot.cursor.fg}

      [cursor]
      style=block

      [main]
      dpi-aware=yes
      font=${colors.fonts.monospace}:size=10
    '';
    destination = "/foot.ini";
    executable = false;
  };
in
configuration
