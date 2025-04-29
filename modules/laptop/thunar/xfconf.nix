{ home-manager, vars, ... }:

{
  programs.xfconf.enable = true;

  home-manager.users."${vars.user.name}" = {
    xfconf.settings.thunar = {
      "last-view" = "ThunarIconView";
      "last-icon-view-zoom-level" = "THUNAR_ZOOM_LEVEL_100_PERCENT";
      "last-window-width" = 1902;
      "last-window-height" = 1030;
      "last-window-maximized" = false;
      "last-menubar-visible" = false;
      "last-toolbar-item-order" = "0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17";
      "last-toolbar-visible-buttons" = "1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0";
      "last-statusbar-visible" = false;
      "last-separator-position" = 170;
      "TerminalEmulator" = "foot";
    };
  };
}
