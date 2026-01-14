{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  homepageText = inputs.homepage.lib.makeHomepage {
    layout = [
      (lib.concatMap (x: x) [
        (lib.optional config.vars.network.searxng.enable {
          short = "sx";
          full = "searxng";
          url = "https://${config.vars.network.duckdns.domain}/searxng/";
        })
        (lib.optional config.vars.network.vaultwarden.enable {
          short = "vw";
          full = "vaultwarden";
          url = "https://${config.vars.network.duckdns.domain}/vaultwarden/";
        })
        (lib.optional config.vars.network.i2pd.enable {
          short = "ip";
          full = "i2pd";
          url = "https://${config.vars.network.duckdns.domain}/i2pd/";
        })
        (lib.optional config.vars.network.qbt.enable {
          short = "qb";
          full = "qbittorrent";
          url = "https://${config.vars.network.duckdns.domain}/qbt/";
        })
        (lib.optional config.vars.network.jellyfin.enable {
          short = "jf";
          full = "jellyfin";
          url = "https://${config.vars.network.duckdns.domain}/jellyfin/";
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
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    appendHttpConfig = ''
      error_log syslog:server=unix:/dev/log;
      access_log syslog:server=unix:/dev/log combined;
    '';
  };

  services.nginx.virtualHosts."${config.vars.network.duckdns.domain}" = {
    locations."/" = {
      root = homepageDir;
      index = "home.html";
    };
  };
}
