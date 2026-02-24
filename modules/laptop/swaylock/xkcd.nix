{
  config,
  inputs,
  pkgs,
  ...
}:

let
  xkcd-config = pkgs.writeText "xkcd-config.json" (
    builtins.toJSON {
      background-colors = config.colors.xkcd.bgs;
      foreground-colors = config.colors.xkcd.fgs;
      dimensions = config.vars.displays.outputs.${config.vars.displays.primary}.resolution;
    }
  );

  fallback = config.wallpapers.oc.nixos;

  target = "/home/${config.vars.user.name}/.local/share/xkcd.png";

  xkcd-refresh = pkgs.writeShellScriptBin "xkcd-refresh" ''
    ${inputs.xkcd.packages.x86_64-linux.default}/bin/xkcd-wall -t random -c "${xkcd-config}" "${target}" || cp "${fallback}" "${target}"; chmod 777 "${target}"
  '';
in
{
  inherit xkcd-refresh;
}
