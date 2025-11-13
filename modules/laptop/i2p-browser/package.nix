{
  pkgs,
  colors,
  vars,
  ...
}:

let
  policies = import ./policies.nix;
  profile = import ./profile.nix { inherit pkgs colors vars; };

  policiesFirefox = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = policies.policies;
  };
in
{
  i2pBrowser = pkgs.writeShellScriptBin "i2p-browser" ''
    #!${pkgs.runtimeShell}
    set -euo pipefail

    baseProfile="${profile.i2pProfile}"
    timestamp="$(${pkgs.coreutils}/bin/date +%s)"
    tmpProfile="/tmp/i2p-browser-''${timestamp}"

    ${pkgs.coreutils}/bin/mkdir -p "$tmpProfile"
    ${pkgs.coreutils}/bin/cp -r --no-preserve=mode,ownership,timestamps "$baseProfile"/* "$tmpProfile"/

    exec ${policiesFirefox}/bin/firefox \
      --no-remote \
      --profile "$tmpProfile" \
      "$@"
  '';
}
