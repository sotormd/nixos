{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.vars.services)
    nginx
    searxng
    vaultwarden
    i2pd
    qbt
    jellyfin
    ;

  homepageText = inputs.homepage.lib.makeHomepage {
    layout = [
      (lib.flatten [
        (lib.optional searxng.enable {
          short = "sx";
          full = "searxng";
          url = "https://${nginx.domain}/searxng/";
        })
        (lib.optional vaultwarden.enable {
          short = "vw";
          full = "vaultwarden";
          url = "https://${nginx.domain}/vaultwarden/";
        })
        (lib.optional i2pd.enable {
          short = "ip";
          full = "i2pd";
          url = "https://${nginx.domain}/i2pd/";
        })
        (lib.optional qbt.enable {
          short = "qb";
          full = "qbittorrent";
          url = "https://${nginx.domain}/qbt/";
        })
        (lib.optional jellyfin.enable {
          short = "jf";
          full = "jellyfin";
          url = "https://${nginx.domain}/jellyfin/";
        })
      ])
    ];
    n = 1;
  };

  homepageFile = pkgs.writeTextFile {
    name = "home.html";
    text = homepageText;
    destination = "/home.html";
  };

  homepageDir = pkgs.symlinkJoin {
    name = "nginx-home";
    paths = [ homepageFile ];
  };
in
lib.mkIf nginx.enable {

  services.nginx.virtualHosts.${nginx.domain} = {
    locations."/" = {
      root = homepageDir;
      index = "home.html";
    };
  };

}
