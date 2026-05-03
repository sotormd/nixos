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

  fallback = config.wallpapers.nord.nixos;
  target = "/home/${config.vars.user.name}/.local/share/xkcd.png";
  backup = "/home/${config.vars.user.name}/.local/share/xkcd.last.png";

  xkcdWrapped = pkgs.writeTextFile {
    name = "xkcd-wrapped";
    text = ''
      #!${pkgs.runtimeShell}

      ${pkgs.coreutils}/bin/cp -f "${target}" "${backup}" 2>/dev/null || ${pkgs.coreutils}/bin/true
      ${inputs.xkcd.packages.x86_64-linux.default}/bin/xkcd-wall -t random -c "${configuration}/config.json" "${target}" || cp "${fallback}" "${target}"; chmod 777 "${target}"
    '';
    destination = "/bin/xkcd-refresh";
    executable = true;
  };
in
{
  inherit xkcdWrapped;
}
