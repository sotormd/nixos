let
  # flake.lock lockfile
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  # pins, we get it from the flake.lock
  # we only source the toplevel pins, dependencies are not sourced
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

  # additional lib functions
  lib = pkgs.lib // (import ./lib);

  # the old variables interface, now using options!
  legacyVars = import ./vars/vars.nix;
  legacySops = ./vars/secrets.yaml;

  # features as modules
  modules = import ./modules;

  # profiles, collections of modules
  profiles = import ./profiles;

  # create a module
  mkModule = type: role: (_: { imports = [ ./roles/${type}-${role} ]; });

  # create a machine module
  mkMachineModule = role: mkModule "machine" role;

  # create an image module
  mkImageModule = role: mkModule "image" role;

  # create a full configuration
  mkConfig =
    module: args: system:
    (import "${pkgs.path}/nixos/lib/eval-config.nix") {
      specialArgs = args // {
        inherit inputs self lib;
      };
      inherit lib system;
      modules = [
        module
      ]
      ++ [
        { nixpkgs.overlays = [ (_: _: { inherit lib; }) ]; }
        { environment.sessionVariables.NIXOS_NONFLAKE = 1; }
      ];
    };

  # create a "machine" - partially applied
  mkMachine = role: mkConfig (mkMachineModule role) { inherit legacyVars legacySops; };

  # create an "image" - partially applied
  mkImage = role: mkConfig (mkImageModule role) { };

  # targets
  targets = fromTOML (builtins.readFile ./targets.toml);

  # machine & image nixosConfigurations
  machineConfigurations = lib.listToAttrs (
    map (m: lib.nameValuePair "machine-${m.name}-${m.arch}" (mkMachine m.name m.arch)) targets.machines
  );
  imageConfigurations = lib.listToAttrs (
    map (i: lib.nameValuePair "image-${i.name}-${i.arch}" (mkImage i.name i.arch)) targets.images
  );

  # image nixosModules
  imageModules = lib.listToAttrs (
    map (i: lib.nameValuePair "image-${i.name}" (mkImageModule i.name)) targets.images
  );
  imageRemoteModules = lib.listToAttrs (
    map (
      i: lib.nameValuePair "image-${i.name}-remote" (mkImageModule "${i.name}-remote")
    ) targets.images
  );

  # nixosConfigurations & nixosModules
  nixosConfigurations = machineConfigurations // imageConfigurations;
  nixosModules = modules // profiles // imageModules // imageRemoteModules;

  # everything to expose
  self = { inherit lib nixosModules nixosConfigurations; };
in
self
