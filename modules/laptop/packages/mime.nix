{ vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    xdg.mimeApps.enable = true;

    xdg.mimeApps.defaultApplications = {
      "image/png" = "swayimg.desktop";
      "image/jpeg" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";

      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";

      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/ogg" = "mpv.desktop";

      "application/pdf" = "org.pwmt.zathura.desktop";

      "text/plain" = "mousepad.desktop";

      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "image/svg+xml" = "brave-browser.desktop";

      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/gzip" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";

      "text/x-shellscript" = "codium.desktop";
      "text/x-python" = "codium.desktop";
      "text/x-rustsrc" = "codium.desktop";
      "text/x-nix" = "codium.desktop";
      "text/x-c" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "application/json" = "codium.desktop";
      "application/x-yaml" = "codium.desktop";
      "application/xml" = "codium.desktop";
    };

    xdg.desktopEntries."brave-browser".settings = {
      Name = "Brave Web Browser";
      Exec = "/run/current-system/sw/bin/brave %U";
      Icon = "brave-browser";
      Type = "Application";
    };
  };
}
