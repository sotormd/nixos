{
  pkgs,
  config,
  vars,
  ...
}:

let
  package = import ./package.nix { inherit pkgs config; };

  hmWrapper = pkgs.vscodium.overrideAttrs (oldAttrs: {
    postInstall = ''
      rm -f $out/bin/codium

      cat > $out/bin/codium <<EOF
      #! /usr/bin/env bash
      exec /run/current-system/sw/bin/codium "\$@"
      EOF

      chmod +x $out/bin/codium
    '';
  });
in
{
  programs.firejail.wrappedBinaries.codium = {
    executable = "${package.customCodium}/bin/codium";
    profile = "${pkgs.firejail}/etc/firejail/codium.profile";
    extraArgs = [
      "--nonewprivs"
      "--net=none"
    ];
  };

  home-manager.users."${vars.user.name}" = {
    programs.vscode.package = hmWrapper;
  };
}
