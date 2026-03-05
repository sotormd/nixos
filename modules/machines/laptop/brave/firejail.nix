{
  config,
  pkgs,
  ...
}:

let
  firejailArgs = [
    "--nonewprivs"
    "--whitelist=/home/${config.vars.user.name}/.local/share/home.html"

    "--caps.drop=all"

    "--nodvd"
    "--nogroups"
    "--noprinters"
    "--noroot"
    "--nou2f"

    "--private-cache"
    "--private-cwd"
    "--private-dev"
    "--private-etc=chromium,brave,resolv.conf,hosts"
  ];

  package = import ./package.nix { inherit pkgs config; };
  webappsFile = import ./webapps.nix;

  webappTemplateScript =
    { name, url }:
    pkgs.writeShellScriptBin name ''
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
      extraArgs = firejailArgs;
    };
  }
  // builtins.mapAttrs (name: script: {
    executable = "${script}/bin/${name}";
    profile = "${pkgs.firejail}/etc/firejail/brave.profile";
    extraArgs = firejailArgs;
  }) webappScripts;
}
