{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  homepageText = inputs.homepage.lib.makeHomepage {
    layout = [
      (lib.concatMap (x: x) [
        (lib.optional config.vars.services.searxng.enable {
          short = "sx";
          full = "searxng";
          url = "https://${config.vars.network.domain}/searxng/";
        })
        (lib.optional config.vars.services.vaultwarden.enable {
          short = "vw";
          full = "vaultwarden";
          url = "https://${config.vars.network.domain}/vaultwarden/";
        })
        (lib.optional config.vars.services.i2pd.enable {
          short = "ip";
          full = "i2pd";
          url = "https://${config.vars.network.domain}/i2pd/";
        })
        (lib.optional config.vars.services.qbt.enable {
          short = "qb";
          full = "qbittorrent";
          url = "https://${config.vars.network.domain}/qbt/";
        })
        (lib.optional config.vars.services.jellyfin.enable {
          short = "jf";
          full = "jellyfin";
          url = "https://${config.vars.network.domain}/jellyfin/";
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
{
  services.nginx.virtualHosts.${config.vars.network.domain} = {
    locations."/" = {
      root = homepageDir;
      index = "home.html";
    };
  };
}
