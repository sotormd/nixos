{ config, pkgs, ... }:

{
  users.users.${config.vars.user.name}.packages = [
    (pkgs.makeDesktopItem {
      name = "brave-browser";
      desktopName = "Brave Web Browser";
      genericName = "Web Browser";
      comment = "Access the Internet";
      exec = "brave %U";
      icon = "brave-browser";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "application/pdf"
        "application/rdf+xml"
        "application/rss+xml"
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/webp"
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      startupNotify = true;

      extraConfig = {
        Actions = "new-window;new-private-window;";
      };

      actions = {
        "new-window" = {
          name = "New Window";
          exec = "brave";
        };
        "new-private-window" = {
          name = "New Incognito Window";
          exec = "brave --incognito";
        };
      };
    })
  ];
}
