{
  lib,
  vars,
  makeHomepage,
  ...
}:

let
  layout = lib.concatMap (x: x) [
    (lib.optional vars.network.server.enable [
      {
        short = "sx";
        full = "searxng";
        url = "https://${vars.network.server.domain}/searxng/";
      }
      {
        short = "vw";
        full = "vaultwarden";
        url = "https://${vars.network.server.domain}/vaultwarden/";
      }
      {
        short = "ip";
        full = "i2pd";
        url = "https://${vars.network.server.domain}/i2pd/";
      }
      {
        short = "qb";
        full = "qbittorrent";
        url = "https://${vars.network.server.domain}/qbt/";
      }
      {
        short = "jf";
        full = "jellyfin";
        url = "https://${vars.network.server.domain}/jellyfin/";
      }
    ])

    (lib.optional vars.network.server.enable "separator")

    [
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
          short = "mt";
          full = "monkeytype";
          url = "https://monkeytype.com";
        }
        {
          short = "wk";
          full = "wikipedia";
          url = "https://en.wikipedia.org/wiki/Main_Page";
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
          short = "hm";
          full = "hm options";
          url = "https://home-manager-options.extranix.com/release=master?query=&release=master";
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
      ]
    ]
  ];

  homepageHtml = makeHomepage {
    inherit layout;
    n = 5;
    font = "IBM Plex Sans";
  };
in
{
  hjem.users.${vars.user.name} = {
    files.".local/share/home.html".text = homepageHtml;
  };
}
