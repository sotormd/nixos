{
  lib,
  writeTextFile,
  homepage,
  vars,
  ...
}:

let
  choose-search =
    (
      cond: a: b:
      if cond then [ a ] else [ b ]
    )
      vars.selfhosted.searxng.enable;

  basePolicies = {
    # permission settings
    DefaultClipboardSetting = 2;
    DefaultGeolocationSetting = 2;
    DefaultInsecureContentSetting = 2;
    DefaultNotificationsSetting = 2;
    DefaultPopupsSetting = 2;
    DefaultSensorsSetting = 2;
    DefaultWebBluetoothGuardSetting = 2;
    DefaultWebHidGuardSetting = 2;
    DefaultWebUsbGuardSetting = 2;

    # strict https only mode
    HttpsOnlyMode = "force_enabled";
    HttpsUpgradesEnabled = true;

    # disable telemetry
    MetricsReportingEnabled = false;

    # disable feedback
    FeedbackSurveysEnabled = false;
    UserFeedbackAllowed = false;

    # disable safe browsing extended reporting which sends data to google
    SafeBrowsingExtendedReportingEnabled = false;

    # disable tor
    # use the tor browser instead
    TorDisabled = true;

    # disable annoying brave anti-features
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = false;
    BraveNewsDisabled = true;
    BraveTalkDisabled = true;
    BraveSpeedreaderEnabled = false;
    BraveWaybackMachineEnabled = false;
    BraveP3AEnabled = false;
    BraveStatsPingEnabled = false;
    BraveWebDiscoveryEnabled = false;
    BravePlaylistEnabled = false;

    # useful brave features
    BraveDeAmpEnabled = true;
    BraveDebouncingEnabled = true;
    BraveReduceLanguageEnabled = true;
    DefaultBraveFingerprintingV2Setting = 3;

    # search engine
    DefaultSearchProviderEnabled = true;

    DefaultSearchProviderImageURL = lib.concatStrings (
      choose-search "https://${vars.selfhosted.searxng.domain}/searxng/static/themes/simple/img/favicon.svg" "https://duckduckgo.com/assets/logo_header_mobile.alt.v109.svg"
    );

    DefaultSearchProviderKeyword = lib.concatStrings (choose-search ":sx" ":ddg");

    DefaultSearchProviderName = lib.concatStrings (choose-search "SearXNG" "DuckDuckGo");

    DefaultSearchProviderSearchURL = lib.concatStrings (
      choose-search "https://${vars.selfhosted.searxng.domain}/searxng/search?q={searchTerms}" "https://duckduckgo.com/?q={searchTerms}"
    );

    # disable the password manager
    PasswordManagerEnabled = false;

    # disable autofill
    AutofillCreditCardEnabled = false;
    AutofillAddressEnabled = false;

    # do not let websites check for saved payment methods
    PaymentMethodQueryEnabled = false;

    # ask where to save each file before downloading
    PromptForDownloadLocation = true;

    # disable autoplay
    AutoplayAllowed = false;

    # disable running background apps
    BackgroundModeEnabled = false;

    # block third party cookied
    BlockThirdPartyCookies = true;

    # disable bookmarks bar
    BookmarkBarEnabled = false;

    # disable printing
    PrintingEnabled = false;

    # webrtc disable non proxied udp
    WebRtcIPHandling = "disable_non_proxied_udp";

    # homepage
    HomepageIsNewTabPage = false;
    HomepageLocation = "file://${homepage}/share/home.html";
    NewTabPageLocation = "file://${homepage}/share/home.html";
    ShowHomeButton = false;

    # new tab on startup
    RestoreOnStartup = 5;

    # disable creating new profiles
    BrowserAddPersonEnabled = false;

    # block external extensions
    BlockExternalExtensions = true;

    # disable 'advanced protection' which requires sending data to google
    AdvancedProtectionAllowed = false;

    # set safebrowsing to standard
    SafeBrowsingProtectionLevel = 1;

    # each site in a different process
    # mitigate spectre-like sidechannel attacks
    SitePerProcess = true;

    # disable chrome dino
    AllowDinosaurEasterEgg = false;

    # do not use the builtin pdf reader
    AlwaysOpenPdfExternally = true;

    # do not send domain reliability data to google
    DomainReliabilityAllowed = false;

    # disable media recommendations
    MediaRecommendationsEnabled = false;

    # memory saver maximum savings
    MemorySaverModeSavings = 2;

    # disable shopping list feature
    ShoppingListEnabled = false;

    # block intrusive ads
    AdsSettingForIntrusiveAdsSites = 2;

    # disable suggestions
    SearchSuggestEnabled = false;

    # disable spellcheck
    SpellCheckServiceEnabled = false;
    SpellcheckEnabled = false;

    # disable live translate which sends data to google
    LiveTranslateEnabled = false;

    # disable media router
    EnableMediaRouter = false;

    # disable image label which sends data to google
    AccessibilityImageLabelsEnabled = false;

    # disable time queries to google servers
    BrowserNetworkTimeQueriesEnabled = false;

    # disable google sync
    SyncDisabled = true;

    # disable sending urls to google
    UrlKeyedAnonymizedDataCollectionEnabled = false;

    # disable sending downloads to google
    SafeBrowsingDeepScanningEnabled = false;

    # show full urls
    ShowFullUrlsInAddressBar = true;

    # disable V8
    DefaultJavaScriptJitSetting = 2;
    DefaultJavaScriptOptimizerSetting = 2;
    JavaScriptJitAllowedForSites = [ vars.selfhosted.vaultwarden.domain ];
    JavaScriptOptimizerAllowedForSites = [ vars.selfhosted.vaultwarden.domain ];

    # disable promotions
    PromotionsEnabled = false;

    # disable dns over https
    # use the wireguard-backed unbound instead
    DnsOverHttpsMode = "off";
  };

  # no manifest v2
  extensionPolicies = {
    ExtensionInstallForcelist = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
  };

  policies = writeTextFile {
    name = "brave-policies";
    text = builtins.toJSON (basePolicies // extensionPolicies);
    destination = "/extra.json";
    executable = false;
  };
in
policies
