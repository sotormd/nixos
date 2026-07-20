{ mpv, mpvScripts, ... }:

let
  mpvWithScripts = mpv.override { scripts = [ mpvScripts.mpris ]; };
in
mpvWithScripts
