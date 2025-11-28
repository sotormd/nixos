{ pkgs, colors, ... }:

let
  zathurarc = pkgs.writeTextFile {
    name = "zathurarc";
    text = ''
      set notification-error-bg      "#${colors.zathura.notification.error.bg}"
      set notification-error-fg      "#${colors.zathura.notification.error.fg}"
      set notification-warning-bg    "#${colors.zathura.notification.warning.bg}"
      set notification-warning-fg    "#${colors.zathura.notification.warning.fg}"
      set notification-bg            "#${colors.zathura.notification.normal.bg}"
      set notification-fg            "#${colors.zathura.notification.normal.fg}"

      set completion-bg              "#${colors.zathura.completion.bg}"
      set completion-fg              "#${colors.zathura.completion.fg}"
      set completion-group-bg        "#${colors.zathura.completion.group.bg}"
      set completion-group-fg        "#${colors.zathura.completion.group.fg}"
      set completion-highlight-bg    "#${colors.zathura.completion.highlight.bg}"
      set completion-highlight-fg    "#${colors.zathura.completion.highlight.fg}"

      set index-bg                   "#${colors.zathura.index.bg}"
      set index-fg                   "#${colors.zathura.index.fg}"
      set index-active-bg            "#${colors.zathura.index.active.bg}"
      set index-active-fg            "#${colors.zathura.index.active.fg}"

      set inputbar-bg                "#${colors.zathura.inputbar.bg}"
      set inputbar-fg                "#${colors.zathura.inputbar.fg}"

      set statusbar-bg               "#${colors.zathura.statusbar.bg}"
      set statusbar-fg               "#${colors.zathura.statusbar.fg}"

      set highlight-color            "#${colors.zathura.highlight}"

      set default-bg                 "#${colors.zathura.default.bg}"
      set default-fg                 "#${colors.zathura.default.fg}"

      set render-loading             "true"
      set render-loading-bg          "#${colors.zathura.renderLoading.bg}"
      set render-loading-fg          "#${colors.zathura.renderLoading.fg}"

      set recolor-lightcolor         "#${colors.zathura.recolor.light}"
      set recolor-darkcolor          "#${colors.zathura.recolor.dark}"
      set recolor                    "true"

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
