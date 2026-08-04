let

  # curried function to create mkConfig
  mkConfigBuilder =
    {
      nixos,
      flakeInputs,
      flakeSelf,
      flakeLib,
      nonflake,
    }:

    # create a "config"
    {

      # required
      role,
      system,

      # can be used to provide variables and secrets
      vars ? null,
      sops ? null,

      # can be used to add extra modules
      extraModules ? [ ],

      # probably should not override these
      inputs ? flakeInputs,
      self ? flakeSelf,
      lib ? flakeLib,

    }:

    nixos {

      specialArgs = {
        inherit inputs self lib;
      }
      // (if (vars != null) then { inherit vars; } else { })
      // (if (sops != null) then { inherit sops; } else { });

      inherit system;

      modules = extraModules ++ [

        # role module
        (
          { self, ... }:

          {
            imports = [ self.nixosModules.roles.${role} ];
          }
        )

        # lib overlay for things that use pkgs.lib instead of specialArgs
        # eg, pkgs.callPackage
        { nixpkgs.overlays = [ (_: _: { inherit lib; }) ]; }

        # NIXOS_NONFLAKE value
        { environment.sessionVariables.NIXOS_NONFLAKE = if nonflake then 1 else 0; }

        # place the flake that built the current configuration
        # in /etc/current-flake, for ease-of-use with tools
        # like nixos-enter, in case the flake contains
        # changes that have not been staged yet
        (
          if nonflake then
            { }
          else
            (
              { self, ... }:

              {
                environment.etc."current-flake".source = self;
              }
            )
        )

      ];

    };

  # variables interface, now using options!
  vars = import ./vars/vars.nix;
  sops = ./vars/secrets.yaml;

  # features as modules
  modules = import ./modules;

  # profiles, collections of modules
  profiles = import ./profiles;

  # roles, final outputs
  roles = import ./roles;

  # targets
  targets = fromTOML (builtins.readFile ./targets.toml);

  # machine & image nixosConfigurations
  nixosConfigurations =
    { mkConfig }:
    let
      machineConfigurations = builtins.listToAttrs (
        map (m: {
          name = "machine-${m.name}-${m.arch}";
          value = mkConfig {
            role = "machine-${m.name}";
            system = m.arch;
            inherit vars sops;
          };
        }) targets.machines
      );

      imageConfigurations = builtins.listToAttrs (
        map (i: {
          name = "image-${i.name}-${i.arch}";
          value = mkConfig {
            role = "image-${i.name}";
            system = i.arch;
          };
        }) targets.images
      );
    in
    machineConfigurations // imageConfigurations;

  # final nixosModules
  nixosModules = modules // profiles // roles;

in
{
  inherit
    mkConfigBuilder
    nixosConfigurations
    nixosModules
    ;
}
