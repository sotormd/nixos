{
  lib,
  writeShellScript,
  nix-update,
}:

writeShellScript "updater-nix-update" "${lib.getExe nix-update} \"$@\""
