{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) createHome colors;

  inherit (config.svcfg) nginx;
  inherit (config.svcfg.nginx.locations)
    searxng
    vaultwarden
    i2pd
    qbt
    ;

  homepageText = createHome {
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
      ])
    ];
    n = 1;
    colors = {
      inherit (colors.homepage)
        bg
        btnbg
        fg
        accent
        hover
        ;
    };
    font = colors.fonts.normal;
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
  services.nginx.virtualHosts.${nginx.domain} = {
    locations."/" = {
      root = homepageDir;
      index = "home.html";
    };
  };
}
