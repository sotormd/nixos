{ config, pkgs, ... }:

let
  userJs = pkgs.writeTextFile {
    name = "i2p-browser-userjs";
    text = ''
      user_pref("network.proxy.type", 1);
      user_pref("network.proxy.http", "${config.vars.network.server.address}");
      user_pref("network.proxy.http_port", 4444);
      user_pref("network.proxy.ssl", "${config.vars.network.server.address}");
      user_pref("network.proxy.ssl_port", 4444);
      user_pref("network.proxy.no_proxies_on", "");

      user_pref("browser.urlbar.suggest.bookmark", false);
      user_pref("browser.urlbar.suggest.engines", false);
      user_pref("browser.urlbar.suggest.history", true);
      user_pref("browser.urlbar.suggest.openpage", false);
      user_pref("browser.urlbar.suggest.topsites", false);

      user_pref("privacy.fingerprintingProtection", true);
      user_pref("privacy.fingerprintingProtection.pbmode", true);
      user_pref("privacy.resistFingerprinting", true);
      user_pref("privacy.resistFingerprinting.pbmode", true);

      user_pref("permissions.default.camera", 2);
      user_pref("permissions.default.desktop-notification", 2);
      user_pref("permissions.desktop-notification.notNow.enabled", false);
      user_pref("permissions.desktop-notification.postPrompt.enabled", false);
      user_pref("permissions.default.geo", 2);
      user_pref("permissions.default.image", 1);
      user_pref("permissions.default.microphone", 2);
      user_pref("permissions.default.screen-wake-lock", 2);
      user_pref("permissions.default.xr", 2);
      user_pref("permissions.default.shortcuts", 2);

      user_pref("browser.tabs.inTitlebar", 0);
      user_pref("font.default.x-western", "sans-serif");
      user_pref("font.name.sans-serif.x-western", "${config.colors.fonts.normal}");
      user_pref("font.name.serif.x-western", "${config.colors.fonts.normal}");
      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

      user_pref("media.peerconnection.enabled", false);
      user_pref("media.peerConnection.ice.proxy_only", true);
      user_pref("media.navigator.enabled", false);

      user_pref("keyword.enabled", false);
      user_pref("javascript.enabled", false);
      user_pref("browser.urlbar.scotchBonnet.enableOverride", false);
    '';
    destination = "/user.js";
  };

  userChrome = pkgs.writeTextFile {
    name = "i2p-browser-userchrome";
    text = ''
      /* Hide unnecessary toolbar items */
      #urlbar-input::placeholder { color: transparent !important; }
      #firefox-view-button,
      #alltabs-button,
      #unified-extensions-button,
      #star-button-box,
      #picture-in-picture-button,
      #identity-box,
      #tracking-protection-icon-container,
      #reader-mode-button,
      #urlbar .urlbar-go-button,
      #reload-button,
      #stop-button,
      #downloads-button,
      #sidebar-header,
      #sidebar-button { display: none !important; }

      #urlbar-input { padding-left: 20px !important; }
      #urlbar, #searchbar .searchbar-textbox { font-family: ${config.colors.fonts.normal} !important; }

      /* Hide tab strip and related UI */
      #TabsToolbar {
        visibility: collapse !important;
        min-height: 0 !important;
        height: 0 !important;
        overflow: hidden !important;
      }

      #titlebar {
        -moz-appearance: none !important;
      }

      #nav-bar {
        margin-top: 0 !important;
      }

      .tabbrowser-tab {
        min-height: 0 !important;
        height: 0 !important;
        visibility: collapse !important;
      }
    '';
    destination = "/chrome/userChrome.css";
  };

  userContent = pkgs.writeTextFile {
    name = "i2p-browser-usercontent";
    text = ''
      @-moz-document url("about:newtab"), url("about:home") {
        :root[lwt-newtab-brighttext] {
          --newtab-background-color: #2e3440 !important;
        }
      }
    '';
    destination = "/chrome/userContent.css";
  };

  profile = pkgs.symlinkJoin {
    name = "i2p-browser-profile";
    paths = [
      userJs
      userChrome
      userContent
    ];
  };
in
{
  inherit profile;
}
