{ config, pkgs, ... }:

let
  zathurarc = pkgs.writeTextFile {
    name = "zathurarc";
    text = ''
      set notification-error-bg      "#${config.colors.zathura.notification.error.bg}"
      set notification-error-fg      "#${config.colors.zathura.notification.error.fg}"
      set notification-warning-bg    "#${config.colors.zathura.notification.warning.bg}"
      set notification-warning-fg    "#${config.colors.zathura.notification.warning.fg}"
      set notification-bg            "#${config.colors.zathura.notification.normal.bg}"
      set notification-fg            "#${config.colors.zathura.notification.normal.fg}"

      set completion-bg              "#${config.colors.zathura.completion.bg}"
      set completion-fg              "#${config.colors.zathura.completion.fg}"
      set completion-group-bg        "#${config.colors.zathura.completion.group.bg}"
      set completion-group-fg        "#${config.colors.zathura.completion.group.fg}"
      set completion-highlight-bg    "#${config.colors.zathura.completion.highlight.bg}"
      set completion-highlight-fg    "#${config.colors.zathura.completion.highlight.fg}"

      set index-bg                   "#${config.colors.zathura.index.bg}"
      set index-fg                   "#${config.colors.zathura.index.fg}"
      set index-active-bg            "#${config.colors.zathura.index.active.bg}"
      set index-active-fg            "#${config.colors.zathura.index.active.fg}"

      set inputbar-bg                "#${config.colors.zathura.inputbar.bg}"
      set inputbar-fg                "#${config.colors.zathura.inputbar.fg}"

      set statusbar-bg               "#${config.colors.zathura.statusbar.bg}"
      set statusbar-fg               "#${config.colors.zathura.statusbar.fg}"

      set highlight-color            "${config.colors.zathura.highlight}"

      set default-bg                 "#${config.colors.zathura.default.bg}"
      set default-fg                 "#${config.colors.zathura.default.fg}"

      set render-loading             "true"
      set render-loading-bg          "#${config.colors.zathura.renderLoading.bg}"
      set render-loading-fg          "#${config.colors.zathura.renderLoading.fg}"

      set recolor-lightcolor         "#${config.colors.zathura.recolor.light}"
      set recolor-darkcolor          "#${config.colors.zathura.recolor.dark}"
      set recolor                    "true"

      set font "${config.colors.fonts.monospace}"
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
