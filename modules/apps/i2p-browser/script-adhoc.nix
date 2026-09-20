{
  lib,
  coreutils,
  gnused,
  writeShellScriptBin,
  executable,
  profile,
}:

let
  script = writeShellScriptBin "i2p-browser-adhoc-script" ''
    set -euo pipefail

    addr="$1"
    port="$2"
    shift 2

    baseProfile="${profile}"
    timestamp="$(${lib.getExe' coreutils "date"} +%s)"
    tmpProfile="/tmp/i2p-browser-''${timestamp}"

    ${lib.getExe' coreutils "mkdir"} -p "$tmpProfile"
    ${lib.getExe' coreutils "cp"} -r --no-preserve=mode,ownership,timestamps "$baseProfile"/* "$tmpProfile"/

    ${lib.getExe gnused} -i \
      -e "s|^user_pref(\"network\.proxy\.http\", .*);|user_pref(\"network.proxy.http\", \"$addr\");|" \
      -e "s|^user_pref(\"network\.proxy\.ssl\", .*);|user_pref(\"network.proxy.ssl\", \"$addr\");|" \
      -e "s|^user_pref(\"network\.proxy\.http_port\", .*);|user_pref(\"network.proxy.http_port\", $port);|" \
      -e "s|^user_pref(\"network\.proxy\.ssl_port\", .*);|user_pref(\"network.proxy.ssl_port\", $port);|" \
      "$tmpProfile/user.js"

    exec ${lib.getExe executable} \
      --no-remote \
      --profile "$tmpProfile" \
      "$@"
  '';
in
script
