let
  # flake.lock lockfile
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  # pins, we get it from the flake.lock
  # we only source the direct deps, transitive deps are not sourced
  neededPins = builtins.listToAttrs (
    map
      (name: {
        inherit name;
        value = null;
      })
      [
        "nixpkgs"
        "sops-nix"
        "lanzaboote"
        "svcvm"
        "hosts"
        "xkcd"
      ]
  );
  pins = builtins.mapAttrs (_: node: node.locked) (builtins.intersectAttrs neededPins lock.nodes);

  # sources, everything is currently a fetchTarball
  # also everything happens to be from github
  sources = builtins.mapAttrs (
    name: _:
    fetchTarball {
      url = "https://github.com/${pins.${name}.owner}/${pins.${name}.repo}/archive/${pins.${name}.rev}.tar.gz";
      sha256 = pins.${name}.narHash;
    }
  ) pins;

  # the nix packages collection
  pkgs = import sources.nixpkgs { };

  # consumed by the modules
  # it is possible to directly reference sources
  # but inputs dress everything up nicely
  # so that it looks like the flake inputs' outputs
  inputs = {

    # the sops-nix module
    sops-nix.nixosModules.sops = "${sources.sops-nix}/modules/sops";

    # the lanzaboote module
    lanzaboote.nixosModules.lanzaboote =
      (import sources.lanzaboote { inherit pkgs; }).nixosModules.lanzaboote;

    # the svcvm module
    svcvm.nixosModules.host = "${sources.svcvm}/module";

    # the hosts outPath
    hosts.outPath = sources.hosts;

    # the xkcd-wall package
    xkcd.packages.${pkgs.stdenv.hostPlatform.system}.default = import sources.xkcd { inherit pkgs; };

  };

  # helpers
  helpers = import ./helpers.nix;

  # additional lib functions
  lib = (import ./lib) // {
    inherit mkConfig;
  };

  # non-flake mkConfig
  mkConfig = helpers.mkConfigBuilder {
    nixos = import "${pkgs.path}/nixos/lib/eval-config.nix";
    flakeInputs = inputs;
    flakeSelf = self;
    flakeLib = pkgs.lib // lib;
    nonflake = true;
  };

  # nixosConfigurations & nixosModules
  nixosConfigurations = helpers.nixosConfigurations { inherit mkConfig; };
  inherit (helpers) nixosModules;

  # everything to expose
  self = { inherit lib nixosModules nixosConfigurations; };
in
self
