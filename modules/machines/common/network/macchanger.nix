{ pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "macchanger-reload" ''
    ${pkgs.iproute2}/bin/ip link set dev "$1" down
    ${pkgs.macchanger}/bin/macchanger -r "$1"
    ${pkgs.iproute2}/bin/ip link set dev "$1" up
  '';
in
{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", NAME!="lo", RUN+="${script}/bin/macchanger-reload %k"
  '';
}
