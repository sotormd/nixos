{
  coreutils,
  runtimeShell,
  writeTextFile,
  executable,
  profile,
  ...
}:

let
  script = writeTextFile {
    name = "i2p-browser-script";
    text = ''
      #!${runtimeShell}

      set -euo pipefail

      baseProfile="${profile}"
      timestamp="$(${coreutils}/bin/date +%s)"
      tmpProfile="/tmp/i2p-browser-''${timestamp}"

      ${coreutils}/bin/mkdir -p "$tmpProfile"
      ${coreutils}/bin/cp -r --no-preserve=mode,ownership,timestamps "$baseProfile"/* "$tmpProfile"/

      exec ${executable}/bin/firefox \
        --no-remote \
        --profile "$tmpProfile" \
        "$@"
    '';
    destination = "/bin/i2p-browser";
    executable = true;
  };
in
script
