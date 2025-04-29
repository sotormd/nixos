{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    programs.firefox.package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        AppAutoUpdate = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        BackgroundAppUpdate = false;
        DisableAccounts = true;
        DisableEncryptedClientHello = false;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisableForgetButton = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never";
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = true;
        };
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        Homepage = {
          URL = "file:///home/${vars.user.name}/.local/share/home.html";
          Locked = true;
        };
        HttpsOnlyMode = "force_enabled";
        MicrosoftEntraSSO = false;
        NewTabPage = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PictureInPicture = {
          Enabled = true;
          Locked = true;
        };
        PostQuantumKeyAgreementEnabled = true;
        PromptForDownloadLocation = true;
        SanitizeOnShutdown = {
          Cache = false;
          Cookies = false;
          History = false;
          Sessions = true;
          SiteSettings = false;
          Locked = true;
        };
        SearchSuggestEnabled = false;
        ShowHomeButton = false;
        TranslateEnabled = false;
        WindowsSSO = false;
      };
    };
  };
}
