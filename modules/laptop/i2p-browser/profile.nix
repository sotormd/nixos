{
  config,
  pkgs,
  vars,
  ...
}:

let
  userJs = pkgs.writeTextFile {
    name = "firefox-i2p-userjs";
    text = builtins.readFile (
      pkgs.replaceVars ./profile/user.js {
        routerIP = "${vars.network.server.ip}";
        routerPort = "${vars.network.server.ip}";
        fontsNormal = "${config.colors.fonts.normal}";
      }
    );
    destination = "/user.js";
  };

  userChrome = pkgs.writeTextFile {
    name = "firefox-i2p-userchrome";
    text = builtins.readFile (
      pkgs.replaceVars ./profile/userChrome.css {
        fontsNormal = "${config.colors.fonts.normal}";
      }
    );
    destination = "/chrome/userChrome.css";
  };

  userContent = pkgs.writeTextFile {
    name = "firefox-i2p-usercontent";
    text = builtins.readFile (
      pkgs.replaceVars ./profile/userContent.css {
        colorDark = "${config.colors.bg0}";
      }
    );
    destination = "/chrome/userContent.css";
  };
in
{
  i2pProfile = pkgs.symlinkJoin {
    name = "firefox-i2p-profile";
    paths = [
      userJs
      userChrome
      userContent
    ];
  };
}
