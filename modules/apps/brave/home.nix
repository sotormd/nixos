{
  inputs,
  lib,
  writeTextFile,
  colors,
  vars,
  ...
}:

let
  layout = [

    (lib.flatten [
      (lib.optional vars.selfhosted.searxng.enable [
        {
          short = "sx";
          full = "searxng";
          url = "https://${vars.selfhosted.searxng.domain}/searxng/";
        }
      ])
      (lib.optional vars.selfhosted.vaultwarden.enable [
        {
          short = "vw";
          full = "vaultwarden";
          url = "https://${vars.selfhosted.vaultwarden.domain}/vaultwarden/";
        }
      ])
      (lib.optional vars.selfhosted.i2pd.enable [
        {
          short = "ip";
          full = "i2pd";
          url = "https://${vars.selfhosted.i2pd.domain}/i2pd/";
        }
      ])
      (lib.optional vars.selfhosted.qbt.enable [
        {
          short = "qb";
          full = "qbittorrent";
          url = "https://${vars.selfhosted.qbt.domain}/qbt/";
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
    ]
  ];

  homepageHtml = inputs.homepage.lib.makeHomepage {
    inherit layout;
    n = 4;
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

  homepage = writeTextFile {
    name = "homepage";
    text = homepageHtml;
    destination = "/share/home.html";
    executable = false;
  };
in
homepage
