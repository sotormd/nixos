{
  lib,
  coreutils,
  writeShellScriptBin,
  executable,
  profile,
}:

let
  script = writeShellScriptBin "i2p-browser-script" ''
    set -euo pipefail

    baseProfile="${profile}"
    timestamp="$(${lib.getExe' coreutils "date"} +%s)"
    tmpProfile="/tmp/i2p-browser-''${timestamp}"

    ${lib.getExe' coreutils "mkdir"} -p "$tmpProfile"
    ${lib.getExe' coreutils "cp"} -r --no-preserve=mode,ownership,timestamps "$baseProfile"/* "$tmpProfile"/

    exec ${lib.getExe executable} \
      --no-remote \
      --profile "$tmpProfile" \
      "$@"
  '';
in
script
