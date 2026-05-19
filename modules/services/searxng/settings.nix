{ config, lib, ... }:

let
  inherit (config.vars.services) nginx searxng;
in
{
  config = lib.mkIf searxng.enable {

    services.searx.settings = {
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
        base_url = "https://${nginx.domain}/searxng";
        secret_key = config.sops.secrets.searxng.path;
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
}
