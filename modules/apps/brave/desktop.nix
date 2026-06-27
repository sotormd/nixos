{ makeDesktopItem, ... }:

let
  desktop = makeDesktopItem {
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
  };
in
desktop
