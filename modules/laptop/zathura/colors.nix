{
  home-manager,
  vars,
  colors,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    programs.zathura.options = {
      notification-error-bg = "#${colors.bg0}";
      notification-error-fg = "#${colors.red}";
      notification-warning-bg = "#${colors.bg0}";
      notification-warning-fg = "#${colors.orange}";
      notification-bg = "#${colors.bg0}";
      notification-fg = "#${colors.fg0}";

      completion-bg = "#${colors.bg0}";
      completion-fg = "#${colors.fg0}";
      completion-group-bg = "#${colors.bg1}";
      completion-group-fg = "#${colors.fg0}";
      completion-highlight-bg = "#${colors.blue1}";
      completion-highlight-fg = "#${colors.bg1}";

      index-bg = "#${colors.bg0}";
      index-fg = "#${colors.blue0}";
      index-active-bg = "#${colors.blue0}";
      index-active-fg = "#${colors.bg0}";

      inputbar-bg = "#${colors.bg0}";
      inputbar-fg = "#${colors.fg1}";

      statusbar-bg = "#${colors.bg0}";
      statusbar-fg = "#${colors.fg1}";

      highlight-color = "rgba(129, 161, 193, 0.5)";

      default-bg = "#${colors.bg0}";
      default-fg = "#${colors.fg0}";
      render-loading = true;
      render-loading-bg = "#${colors.bg0}";
      render-loading-fg = "#${colors.bg2}";

      recolor-lightcolor = "#${colors.bg0}";
      recolor-darkcolor = "#${colors.fg2}";
      recolor = true;
    };
  };
}
