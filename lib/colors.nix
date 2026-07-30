let
  colors = rec {
    # polar night
    bg0 = "2e3440";
    bg1 = "3b4252";
    bg2 = "434c5e";
    bg3 = "4c566a";

    # snow storm
    fg0 = "d8dee9";
    fg1 = "e5e9f0";
    fg2 = "eceff4";

    # frost
    blue0 = "8fbcbb";
    blue1 = "88c0d0";
    blue2 = "81a1c1";
    blue3 = "5e81ac";

    # aurora
    red = "bf616a";
    orange = "d08770";
    yellow = "ebcb8b";
    green = "a3be8c";
    purple = "b48ead";

    # inkscape
    inkscape = {
      pagecolor = bg0;
      deskcolor = bg0;
      bordercolor = bg3;
    };

    # xkcd
    xkcd = {
      bg = bg0;
      fg = fg0;
    };

    # gtk
    gtk = {
      theme = {
        package = "nordic";
        name = "Nordic-darker";
      };
      icons = {
        package = "nordzy-icon-theme";
        name = "Nordzy-dark";
      };
      cursor = {
        package = "simp1e-cursors";
        name = "Simp1e-Nord-Dark";
      };
    };

    # fonts
    fonts = {
      packages = [
        "ibm-plex"
        "jetbrains-mono"
        "noto-fonts-color-emoji"
      ];
      nerdfonts = [ "im-writing" ];
      monospace = "JetBrains Mono";
      normal = "IBM Plex Sans";
      sansserif = "IBM Plex Sans";
      serif = "IBM Plex Serif";
    };

    # homepage
    homepage = {
      bg = bg0;
      btnbg = bg3;
      fg = fg0;
      accent = blue2;
      hover = [
        red
        orange
        yellow
        green
        purple
      ];
    };

    # waybar
    waybar = {
      mode.text = blue2;
      workspaces = {
        border = blue2;
        text = blue2;
        hover = bg3;
      };
      modules.text = bg1;
      util.bg = red;
      network.bg = orange;
      audio.bg = yellow;
      battery.bg = green;
      clock.bg = purple;
    };

    # foot
    foot = {
      bg = bg0;
      fg = fg0;
      cursor = {
        bg = bg0;
        fg = fg0;
      };
      regular0 = bg1;
      regular1 = red;
      regular2 = green;
      regular3 = yellow;
      regular4 = blue2;
      regular5 = purple;
      regular6 = blue1;
      regular7 = fg1;
      bright0 = bg3;
      bright1 = red;
      bright2 = green;
      bright3 = yellow;
      bright4 = blue2;
      bright5 = purple;
      bright6 = blue0;
      bright7 = fg2;
    };

    # rofi
    rofi = {
      border = blue2;
      handle = blue2;
      bgs = {
        normal = bg3;
        alternate = bg2;
        urgent = yellow;
        active = green;
      };
      fgs = {
        normal = fg0;
        urgent = bg3;
        active = bg3;
      };
      selectedBgs = {
        normal = blue2;
        urgent = green;
        active = yellow;
      };
      selectedFgs = {
        normal = bg3;
        urgent = bg3;
        active = bg3;
      };
      alternateBgs = {
        normal = bg3;
        urgent = yellow;
        active = green;
      };
      alternateFgs = {
        normal = fg0;
        urgent = bg3;
        active = bg3;
      };
    };

    # dunst
    dunst = {
      bg = bg0;
      normal = blue2;
      urgent = yellow;
    };

    # swaylock
    swaylock = {
      clear = yellow;
      verifying = blue2;
      wrong = red;
    };

    # sway
    sway = {
      focused = {
        border = blue2;
        background = bg0;
        text = fg0;
        indicator = blue2;
        childBorder = blue2;
      };

      focusedInactive = {
        border = bg3;
        background = bg0;
        text = fg0;
        indicator = bg3;
        childBorder = bg3;
      };

      unfocused = {
        border = bg3;
        background = bg0;
        text = fg0;
        indicator = bg3;
        childBorder = bg3;
      };

      urgent = {
        border = yellow;
        background = bg0;
        text = fg0;
        indicator = yellow;
        childBorder = yellow;
      };

      background = bg0;
    };

    # zathura
    zathura = {
      notification = {
        error = {
          bg = bg0;
          fg = red;
        };
        warning = {
          bg = bg0;
          fg = orange;
        };
        normal = {
          bg = bg0;
          fg = fg0;
        };
      };

      completion = {
        bg = bg0;
        fg = fg0;
        group = {
          bg = bg1;
          fg = fg0;
        };
        highlight = {
          bg = blue1;
          fg = bg1;
        };
      };

      index = {
        bg = bg0;
        fg = blue0;
        active = {
          bg = blue0;
          fg = bg0;
        };
      };

      inputbar = {
        bg = bg0;
        fg = fg1;
      };

      statusbar = {
        bg = bg0;
        fg = fg1;
      };

      default = {
        bg = bg0;
        fg = fg0;
      };

      renderLoading = {
        bg = bg0;
        fg = bg2;
      };

      recolor = {
        light = bg0;
        dark = fg2;
      };

      highlight = "rgba(129, 161, 193, 0.5)";
    };
  };
in
{
  inherit colors;
}
