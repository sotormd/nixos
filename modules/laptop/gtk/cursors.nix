{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    gtk.cursorTheme.package = pkgs.whitesur-cursors;
    gtk.cursorTheme.name = "WhiteSur-cursors";
    gtk.cursorTheme.size = 24;
    home.pointerCursor.package = pkgs.whitesur-cursors;
    home.pointerCursor.name = "WhiteSur-cursors";
    home.pointerCursor.size = 24;
    home.pointerCursor.x11.enable = true;
    home.pointerCursor.x11.defaultCursor = "WhiteSur-cursors";
  };
}
