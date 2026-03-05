{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ./config.nix { inherit config lib pkgs; }) configuration;
  inherit (import ./style.nix { inherit config pkgs; }) style;

  waybarWrapperScript = pkgs.writeTextFile {
    name = "waybar-wrapper-script";
    text = ''
      #!${pkgs.runtimeShell}

      ${pkgs.waybar}/bin/waybar --config ${configuration}/config.json --style ${style}/style.css "$@"
    '';
    destination = "/bin/waybar";
    executable = true;
  };

  waybarWrapped = pkgs.symlinkJoin {
    name = "waybar";
    paths = [ pkgs.waybar ];

    # replace the waybar binary with our wrapper
    postBuild = ''
      rm -f $out/bin/waybar
      ln -s ${waybarWrapperScript}/bin/waybar $out/bin/waybar
    '';
  };
in
{
  inherit waybarWrapped;
}
