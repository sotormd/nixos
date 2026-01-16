{ pkgs, config, ... }:

{
  customCodium = pkgs.vscodium.overrideAttrs (old: {
    postInstall =
      if (config.boot.kernel.sysctl."kernel.unprivileged_userns_clone" == "0") then
        (old.postInstall or "")
        + ''ln -sf /run/wrappers/bin/chrome-sandbox-codium $out/lib/vscode/chrome-sandbox''
      else
        (old.postInstall or "");
  });
}
