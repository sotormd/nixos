{ config, pkgs, ... }:

let
  zathurarc = pkgs.writeTextFile {
    name = "zathurarc";
    text = builtins.readFile (
      pkgs.replaceVars ./config/zathurarc {
        notificationErrorBg = "${config.colors.zathura.notification.error.bg}";
        notificationErrorFg = "${config.colors.zathura.notification.error.fg}";
        notificationWarningBg = "${config.colors.zathura.notification.warning.bg}";
        notificationWarningFg = "${config.colors.zathura.notification.warning.fg}";
        notificationNormalBg = "${config.colors.zathura.notification.normal.bg}";
        notificationNormalFg = "${config.colors.zathura.notification.normal.fg}";

        completionBg = "${config.colors.zathura.completion.bg}";
        completionFg = "${config.colors.zathura.completion.fg}";
        completionGroupBg = "${config.colors.zathura.completion.group.bg}";
        completionGroupFg = "${config.colors.zathura.completion.group.fg}";
        completionHighlightBg = "${config.colors.zathura.completion.highlight.bg}";
        completionHighlightFg = "${config.colors.zathura.completion.highlight.fg}";

        indexBg = "${config.colors.zathura.index.bg}";
        indexFg = "${config.colors.zathura.index.fg}";
        indexActiveBg = "${config.colors.zathura.index.active.bg}";
        indexActiveFg = "${config.colors.zathura.index.active.fg}";

        inputbarBg = "${config.colors.zathura.inputbar.bg}";
        inputbarFg = "${config.colors.zathura.inputbar.fg}";

        statusbarBg = "${config.colors.zathura.statusbar.bg}";
        statusbarFg = "${config.colors.zathura.statusbar.fg}";

        highlight = "${config.colors.zathura.highlight}";

        defaultBg = "${config.colors.zathura.default.bg}";
        defaultFg = "${config.colors.zathura.default.fg}";

        renderLoadingBg = "${config.colors.zathura.renderLoading.bg}";
        renderLoadingFg = "${config.colors.zathura.renderLoading.fg}";

        recolorLight = "${config.colors.zathura.recolor.light}";
        recolorDark = "${config.colors.zathura.recolor.dark}";

        fontsMonospace = "${config.colors.fonts.monospace}";
      }
    );
    destination = "/zathurarc";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "zathura";
    paths = [ zathurarc ];
  };
}
