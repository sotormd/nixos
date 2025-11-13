{ pkgs, colors, ... }:

let
  zathurarc = pkgs.writeTextFile {
    name = "zathurarc";
    text = ''
      set notification-error-bg	"#${colors.bg0}"
      set notification-error-fg	"#${colors.red}"
      set notification-warning-bg	"#${colors.bg0}"
      set notification-warning-fg	"#${colors.orange}"
      set notification-bg	"#${colors.bg0}"
      set notification-fg	"#${colors.fg0}"

      set completion-bg	"#${colors.bg0}"
      set completion-fg	"#${colors.fg0}"
      set completion-group-bg	"#${colors.bg1}"
      set completion-group-fg	"#${colors.fg0}"
      set completion-highlight-bg	"#${colors.blue1}"
      set completion-highlight-fg	"#${colors.bg1}"

      set index-bg	"#${colors.bg0}"
      set index-fg	"#${colors.blue0}"
      set index-active-bg	"#${colors.blue0}"
      set index-active-fg	"#${colors.bg0}"

      set inputbar-bg	"#${colors.bg0}"
      set inputbar-fg	"#${colors.fg1}"

      set statusbar-bg	"#${colors.bg0}"
      set statusbar-fg	"#${colors.fg1}"

      set highlight-color	"rgba(129, 161, 193, 0.5)"

      set default-bg	"#${colors.bg0}"
      set default-fg	"#${colors.fg0}"

      set render-loading	"true"
      set render-loading-bg	"#${colors.bg0}"
      set render-loading-fg	"#${colors.bg2}"

      set recolor-lightcolor	"#${colors.bg0}"
      set recolor-darkcolor	"#${colors.fg2}"
      set recolor	"true"

      set font "${colors.fonts.monospace}"
    '';
    destination = "/zathurarc";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "zathura";
    paths = [ zathurarc ];
  };
}
