{
  config,
  inputs,
  pkgs,
  ...
}:

let
  configuration = pkgs.writeTextFile {
    name = "xkcd-config";
    text = builtins.toJSON {
      background-colors = config.colors.xkcd.bgs;
      foreground-colors = config.colors.xkcd.fgs;
      dimensions = config.vars.displays.outputs.${config.vars.displays.primary}.resolution;
    };
    destination = "/config.json";
    executable = false;
  };

  fallback = config.wallpapers.oc.nixos;

  target = "/home/${config.vars.user.name}/.local/share/xkcd.png";

  xkcdWrapped = pkgs.writeTextFile {
    name = "xkcd-wrapped";
    text = ''
      #!/usr/bin/env bash

      ${inputs.xkcd.packages.x86_64-linux.default}/bin/xkcd-wall -t random -c "${configuration}/config.json" "${target}" || cp "${fallback}" "${target}"; chmod 777 "${target}"
    '';
    destination = "/bin/xkcd-refresh";
    executable = true;
  };
in
{
  inherit xkcdWrapped;
}
