{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.firefox.profiles."${vars.user.name}" = {
      search.default = "SearXNG";
      search.force = true;

      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
            }
          ];
          definedAliases = [ "@np" ];
        };
        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
            }
          ];
          definedAliases = [ "@no" ];
        };
        "Home Manager Options" = {
          urls = [
            { template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }
          ];
          definedAliases = [ "@hm" ];
        };
      };

      search.order = [
        "ddg"
        "Nix Packages"
        "Nix Options"
        "Home Manager Options"
        "google"
        "bing"
        "Wikipedia"
      ];
    };
  };
}
