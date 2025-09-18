{ pkgs, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    gtk.cursorTheme.package = pkgs.simp1e-cursors;
    gtk.cursorTheme.name = "Simp1e-Nord-Dark";
    gtk.cursorTheme.size = 1;
    home.pointerCursor.package = pkgs.simp1e-cursors;
    home.pointerCursor.name = "Simp1e-Nord-Dark";
    home.pointerCursor.size = 1;
    home.pointerCursor.x11.enable = true;
    home.pointerCursor.x11.defaultCursor = "Simp1e-Nord-Dark";
  };
}
