{ firefox-unwrapped, wrapFirefox, ... }:

let
  policies = {
    AppAutoUpdate = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    BackgroundAppUpdate = false;
    BlockAboutAddons = true;
    BlockAboutConfig = true;
    BlockAboutProfiles = true;
    BlockAboutSupport = true;
    DisableAccounts = true;
    DisableBuiltInPDFViewer = true;
    DisableDeveloperTools = true;
    DisableEncryptedClientHello = false;
    DisableFeedbackCommands = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisableForgetButton = true;
    DisableFormHistory = true;
    DisableMasterPasswordCreation = true;
    DisablePasswordReveal = true;
    DisablePocket = true;
    DisableProfileImport = true;
    DisableProfileRefresh = true;
    DisableSecurityBypass = true;
    DisableSetDesktopBackground = true;
    DisableSystemAddonUpdate = true;
    DisableTelemetry = true;
    DisplayBookmarksToolbar = "never";
    DontCheckDefaultBrowser = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
    };
    EncryptedMediaExtensions = {
      Enabled = false;
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
    HttpsOnlyMode = "disallowed";
    InstallAddonsPermission = false;
    MicrosoftEntraSSO = false;
    NewTabPage = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    PasswordManagerEnabled = false;
    PDFjs.Enabled = false;
    PictureInPicture = {
      Enabled = false;
      Locked = true;
    };
    PostQuantumKeyAgreementEnabled = true;
    PrintingEnabled = false;
    PrivateBrowsingModeAvailability = 2;
    PromptForDownloadLocation = true;
    SanitizeOnShutdown = true;
    SearchSuggestEnabled = false;
    ShowHomeButton = false;
    SkipTermsOfUse = true;
    StartDownloadsInTempDirectory = true;
    TranslateEnabled = false;
    WindowsSSO = false;
  };

  firefox = wrapFirefox firefox-unwrapped { extraPolicies = policies; };
in
firefox
