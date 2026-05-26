{ config, pkgs, ... }:

let
  inherit (config.svcfg) searxng;
in
{

  services.searx = {

    # enable the searxng metasearch engine
    enable = true;
    package = pkgs.searxng;

    # searxng settings
    settings = {
      general = {
        debug = false;
        instance_name = "searxng";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };

      ui = {
        static_use_hash = true;
        query_in_title = false;
        infinite_scroll = true;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "dark";
        results_on_new_tab = false;
        search_on_category_select = false;
        url_formatting = "full";
        categories_as_tabs = [ "general" ];
      };

      search = {
        safe_search = 0;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
      };

      server = {
        inherit (searxng) bind_address port;
        base_url = "https://${searxng.domain}/searxng";
        configureUwsgi = false;
        secret_key = "/run/credentials/@system/searxng";
        public_instance = false;
        limiter = false;
        image_proxy = true;
        method = "GET";
      };

      outgoing = {
        request_timeout = 60;
        max_request_timeout = 60;
      };

      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };

  };

  # start after appropriate indicators
  systemd.services.searx = {
    wants = [
      "network-online.target"
      "svcready-interface.service"
      "svcready-resolve.service"
    ];
    after = [
      "network-online.target"
      "svcready-interface.service"
      "svcready-resolve.service"
    ];
  };
}
