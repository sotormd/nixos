{ colors, pkgs, ... }:

let
  initialPreferences = {
    ##################
    # FEATURES
    ##################

    # auto redirect amp pages
    brave.de_amp.enabled = true;

    # auto redirect tracking urls
    brave.debounce.enabled = true;

    # prevent language fingerprinting
    brave.reduce_language = true;

    # automatically remove unused permissions
    safety_hub.unused_site_permissions_revocation.enabled = false;

    # send do not track requests
    enable_do_not_track = true;

    # aggressive trackers and ads blocking
    profile.content_settings.exceptions.cosmeticFiltering."*,*".setting = 2;
    profile.content_settings.exceptions.cosmeticFiltering."*,https://firstparty".setting = 2;

    # block fingerprinting
    profile.content_settings.exceptions.fingerprintingV2."*,*".setting = 3;
    profile.content_settings.exceptions.shieldsAds."*,*".setting = 3;
    profile.content_settings.exceptions.trackers."*,*".setting = 3;

    # block third party cookies
    profile.cookie_controls_mode = 1;

    # strict https upgrades
    profile.default_content_setting_values.httpsUpgrades = 2;
    https_only_mode_enabled = true;

    ##################
    # ANTI-FEATURES
    ##################

    # disable V8
    profile.default_content_setting_values.javascript_jit = 2;

    # disable webtorrent
    brave.webtorrent_enabled = false;

    # disable social media components
    brave.fb_embed_default = false;
    brave.twitter_embed_default = false;
    brave.linkedin_embed_default = false;

    # disable google push messaging services
    brave.gcm.channel_status = false;

    # disable saving contact info
    brave.webcompat.report.enable_save_contact_info = false;

    # disable search suggestions
    search.suggest_enabled = false;

    # history autocompletions only
    brave.omnibox.bookmark_suggestions_enabled = false;
    brave.omnibox.commander_suggestions_enabled = false;
    brave.top_site_suggestions_enabled = false;

    ##################
    # VISUAL SETTINGS
    ##################

    # hide shields count
    brave.shields.stats_badge_visible = false;

    # hide brave ads
    brave.brave_ads.should_allow_ads_subdivision_targeting = false;

    # hide brave rewards
    brave.rewards.badge_text = "";
    brave.rewards.show_brave_rewards_button_in_location_bar = false;
    brave.today.should_show_toolbar_button = false;

    # hide brave wallet
    brave.wallet.show_wallet_icon_on_toolbar = false;

    # hide fullscreen reminder
    brave.show_fullscreen_reminder = false;

    # hide sidebar
    brave.show_side_panel_button = false;

    # hide bookmarks button
    brave.show_bookmarks_button = false;

    # hide tab groups on bookmarks bar
    bookmark_bar.show_tab_groups = false;

    # vertical tabs
    brave.tabs = {
      vertical_tabs_collapsed = true;
      vertical_tabs_enabled = true;
      vertical_tabs_on_right = false;
    };

    # system gtk theme
    extensions.theme.system_theme = 1;

    # zoom
    partition.default_zoom_level.x = -0.5778829311823857;
    partition.per_host_zoom_levels.x = { };

    # fonts
    webkit.webprefs.fonts = {
      fixed.Zyyy = "${colors.fonts.monospace}";
      sansserif.Zyyy = "${colors.fonts.sansserif}";
      serif.Zyyy = "${colors.fonts.serif}";
      standard.Zyyy = "${colors.fonts.normal}";
    };

    #####################
    # EXTENSION SETTINGS
    #####################

    # darkreader: add site to not inverted list
    extensions.commands."linux:Alt+Shift+A" = {
      command_name = "addSite";
      extension = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      global = false;
    };
  };
in
{
  preferencesFile = pkgs.writeText "intial_preferences" (builtins.toJSON initialPreferences);
}
