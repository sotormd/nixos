{ config, pkgs, ... }:

let
  inherit (import ./policies.nix) policies;
  inherit (import ./profile.nix { inherit config pkgs; }) profile;

  script = pkgs.writeTextFile {
    name = "i2p-browser-script";
    text = ''
      #!${pkgs.runtimeShell}

      set -euo pipefail

      baseProfile="${profile}"
      timestamp="$(${pkgs.coreutils}/bin/date +%s)"
      tmpProfile="/tmp/i2p-browser-''${timestamp}"

      ${pkgs.coreutils}/bin/mkdir -p "$tmpProfile"
      ${pkgs.coreutils}/bin/cp -r --no-preserve=mode,ownership,timestamps "$baseProfile"/* "$tmpProfile"/

      exec ${pkgs.wrapFirefox pkgs.firefox-unwrapped { extraPolicies = policies; }}/bin/firefox \
        --no-remote \
        --profile "$tmpProfile" \
        "$@"
    '';
    destination = "/bin/i2p-browser";
    executable = true;
  };
in
{
  inherit script;
}
