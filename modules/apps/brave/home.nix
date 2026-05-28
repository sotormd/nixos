{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  layout = [

    (lib.flatten [
      (lib.optional config.vars.selfhosted.searxng.enable [
        {
          short = "sx";
          full = "searxng";
          url = "https://${config.vars.selfhosted.searxng.domain}/searxng/";
        }
      ])
      (lib.optional config.vars.selfhosted.vaultwarden.enable [
        {
          short = "vw";
          full = "vaultwarden";
          url = "https://${config.vars.selfhosted.vaultwarden.domain}/vaultwarden/";
        }
      ])
      (lib.optional config.vars.selfhosted.i2pd.enable [
        {
          short = "ip";
          full = "i2pd";
          url = "https://${config.vars.selfhosted.i2pd.domain}/i2pd/";
        }
      ])
      (lib.optional config.vars.selfhosted.qbt.enable [
        {
          short = "qb";
          full = "qbittorrent";
          url = "https://${config.vars.selfhosted.qbt.domain}/qbt/";
        }
      ])
      (lib.optional config.vars.selfhosted.qbt.enable [
        {
          short = "tr";
          full = "torrents";
          url = "https://${config.vars.selfhosted.qbt.domain}/torrents/";
        }
      ])
    ])

    "separator"

    [
      {
        short = "op";
        full = "spotify";
        url = "https://open.spotify.com";
      }
      {
        short = "yt";
        full = "youtube";
        url = "https://youtube.com";
      }
      {
        short = "ig";
        full = "instagram";
        url = "https://instagram.com";
      }
      {
        short = "dc";
        full = "discord";
        url = "https://discord.com/channels/@me";
      }
      {
        short = "li";
        full = "lichess";
        url = "https://lichess.org";
      }
      {
        short = "fm";
        full = "lastfm";
        url = "https://last.fm";
      }
      {
        short = "gh";
        full = "github";
        url = "https://github.com";
      }
      {
        short = "cb";
        full = "codeberg";
        url = "https://codeberg.org";
      }
      {
        short = "mt";
        full = "monkeytype";
        url = "https://monkeytype.com";
      }
      {
        short = "ch";
        full = "chatgpt";
        url = "https://chatgpt.com";
      }
      {
        short = "np";
        full = "nix packages";
        url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages";
      }
      {
        short = "no";
        full = "nix options";
        url = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages";
      }
      {
        short = "nw";
        full = "nixos wiki";
        url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
      }
      {
        short = "aw";
        full = "arch wiki";
        url = "https://wiki.archlinux.org/title/Main_page";
      }
      {
        short = "fb";
        full = "freebsd docs";
        url = "https://docs.freebsd.org/en/books/handbook";
      }
    ]
  ];

  homepageHtml = inputs.homepage.lib.makeHomepage {
    inherit layout;
    n = 5;
    colors = {
      inherit (config.colors.homepage)
        bg
        btnbg
        fg
        accent
        hover
        ;
    };
    font = config.colors.fonts.normal;
  };

  homepage = pkgs.writeTextFile {
    name = "homepage";
    text = homepageHtml;
    destination = "/share/home.html";
    executable = false;
  };
in
{
  inherit homepage;
}
