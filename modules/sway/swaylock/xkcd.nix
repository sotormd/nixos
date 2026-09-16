{
  inputs,
  lib,
  coreutils,
  writeShellScriptBin,
  vars,
}:

let
  inherit (lib) colors;

  user = vars.user.name;
  home = "/home/${user}";

  fallback = lib.wallpapers.nord.nixos;
  target = "${home}/.local/share/xkcd.png";
  backup = "${home}/.local/share/xkcd.last.png";

  xkcdWrapped = writeShellScriptBin "xkcd-refresh" ''
    ${lib.getExe' coreutils "cp"} -f "${target}" "${backup}" 2>/dev/null || ${lib.getExe' coreutils "true"}
    ${lib.getExe inputs.xkcd.packages.x86_64-linux.default} \
      -t random \
      -d ${vars.displays.outputs.${vars.displays.primary}.resolution} \
      -b ${colors.xkcd.bg} \
      -f ${colors.xkcd.fg} \
      "${target}" || ${lib.getExe' coreutils "cp"} "${fallback}" "${target}"; ${lib.getExe' coreutils "chmod"} 777 "${target}"
  '';
in
xkcdWrapped
