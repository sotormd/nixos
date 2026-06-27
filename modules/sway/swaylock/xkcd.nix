{
  inputs,
  coreutils,
  runtimeShell,
  writeTextFile,
  colors,
  wallpapers,
  vars,
  ...
}:

let
  configuration = writeTextFile {
    name = "xkcd-config";
    text = builtins.toJSON {
      background-colors = colors.xkcd.bgs;
      foreground-colors = colors.xkcd.fgs;
      dimensions = vars.displays.outputs.${vars.displays.primary}.resolution;
    };
    destination = "/config.json";
    executable = false;
  };

  fallback = wallpapers.nord.nixos;
  target = "/home/${vars.user.name}/.local/share/xkcd.png";
  backup = "/home/${vars.user.name}/.local/share/xkcd.last.png";

  xkcdWrapped = writeTextFile {
    name = "xkcd-wrapped";
    text = ''
      #!${runtimeShell}

      ${coreutils}/bin/cp -f "${target}" "${backup}" 2>/dev/null || ${coreutils}/bin/true
      ${inputs.xkcd.packages.x86_64-linux.default}/bin/xkcd-wall -t random -c "${configuration}/config.json" "${target}" || cp "${fallback}" "${target}"; chmod 777 "${target}"
    '';
    destination = "/bin/xkcd-refresh";
    executable = true;
  };
in
xkcdWrapped
