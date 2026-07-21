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
  fallback = wallpapers.nord.nixos;
  target = "/home/${vars.user.name}/.local/share/xkcd.png";
  backup = "/home/${vars.user.name}/.local/share/xkcd.last.png";

  xkcdWrapped = writeTextFile {
    name = "xkcd-wrapped";
    text = ''
      #!${runtimeShell}

      ${coreutils}/bin/cp -f "${target}" "${backup}" 2>/dev/null || ${coreutils}/bin/true
      ${inputs.xkcd.packages.x86_64-linux.default}/bin/xkcd-wall \
        -t random \
        -d ${vars.displays.outputs.${vars.displays.primary}.resolution} \
        -b ${colors.xkcd.bg} \
        -f ${colors.xkcd.fg} \
        "${target}" || cp "${fallback}" "${target}"; chmod 777 "${target}"
    '';
    destination = "/bin/xkcd-refresh";
    executable = true;
  };
in
xkcdWrapped
