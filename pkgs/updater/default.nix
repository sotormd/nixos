{
  lib,
  writeShellScript,
  nix-update,
}:

writeShellScript "updater" "${lib.getExe nix-update} \"$@\""
