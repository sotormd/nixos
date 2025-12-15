{
  pkgs,
  config,
  colors,
  vars,
  ...
}:

let
  package = import ./package.nix { inherit pkgs config colors; };
  webappsFile = import ./webapps.nix;

  webappTemplateScript =
    { name, url }:
    pkgs.writeShellScriptBin name ''
      #!/usr/bin/env ${pkgs.runtimeShell}
      exec ${package.customBrave}/bin/brave --app=${url}
    '';

  # Generate a set of { name = pathToBinary; ... }
  webappScripts = builtins.mapAttrs (
    name: url: (webappTemplateScript { inherit name url; })
  ) webappsFile.webapps;
in
{
  programs.firejail.wrappedBinaries = {
    brave = {
      executable = "${package.customBrave}/bin/brave";
      profile = "${pkgs.firejail}/etc/firejail/brave.profile";
      extraArgs = [
        "--nonewprivs"
        "--whitelist=/home/${vars.user.name}/.local/share/home.html"
      ];
    };
  }
  // builtins.mapAttrs (name: script: {
    executable = "${script}/bin/${name}";
    profile = "${pkgs.firejail}/etc/firejail/brave.profile";
    extraArgs = [
      "--nonewprivs"
      "--whitelist=/home/${vars.user.name}/.local/share/home.html"
    ];
  }) webappScripts;
}
