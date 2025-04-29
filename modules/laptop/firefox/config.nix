{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.firefox.profiles."${vars.user.name}".settings = {
      "browser.urlbar.suggest.bookmark" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.history" = true;
      "browser.urlbar.suggest.openpage" = false;
      "browser.urlbar.suggest.topsites" = false;
      "privacy.fingerprintingProtection" = true;
      "privacy.fingerprintingProtection.pbmode" = true;
      "privacy.resistFingerprinting" = true;
      "privacy.resistFingerprinting.pbmode" = true;
      "permissions.default.camera" = 2;
      "permissions.default.desktop-notification" = 2;
      "permissions.desktop-notification.notNow.enabled" = false;
      "permissions.desktop-notification.postPrompt.enabled" = false;
      "permissions.default.geo" = 2;
      "permissions.default.image" = 1;
      "permissions.default.microphone" = 2;
      "permissions.default.screen-wake-lock" = 2;
      "permissions.default.xr" = 2;
      "permissions.default.shortcuts" = 2;
      "browser.tabs.inTitlebar" = 0;
      "layout.css.devPixelsPerPx" = 0.9;
      "font.default.x-western" = "sans-serif";
      "font.name.sans-serif.x-western" = "IBM Plex Sans";
      "font.name.serif.x-western" = "IBM Plex Sans";
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };
}
