{ makeDesktopItem, ... }:

let
  desktop = makeDesktopItem {
    name = "i2p-browser-desktop";
    desktopName = "I2P Browser";
    genericName = "Web Browser";
    comment = "Browse the I2P network";
    exec = "i2p-browser %U";
    icon = "firefox";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [ "x-scheme-handler/http" ];
    startupNotify = true;
  };
in
desktop
