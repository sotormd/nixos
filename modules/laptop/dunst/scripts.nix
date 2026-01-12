{ pkgs, vars, ... }:

let
  volume = pkgs.writeShellScriptBin "volume" (builtins.readFile ./scripts/volume.sh);

  brightness = pkgs.writeShellScriptBin "brightness" (
    builtins.readFile (
      pkgs.replaceVars ./scripts/brightness.sh {
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        dunstify = "${pkgs.dunst}/bin/dunstify";
      }
    )
  );
in
{
  users.users.${vars.user.name}.packages = [
    volume
    brightness
  ];
}
