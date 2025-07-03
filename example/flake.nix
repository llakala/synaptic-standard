{
  description = "An example flake following the Synaptic Standard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      lib = inputs.nixpkgs.lib;

      # add to this list if you have more systems
      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = func:
        lib.genAttrs
        supportedSystems
        (system: func inputs.nixpkgs.legacyPackages.${system});

    in
    {
      packages = forAllSystems (pkgs: {
        # Example package: obviously you would actually define a custom package
        # here in practice
        default = pkgs.git;
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          # Also only for demo purposes
          packages = [ pkgs.git ];
        };
      });


      # for easier access, we don't declare each custom module as its own unique
      # flake output. Instead, we have a single `default` module, which imports
      # all the other modules. This mans we only have to import this module
      # once.
      #
      # TODO: use recurseAndFilter here, so new modules don't have to be added
      # manually
      nixosModules.default = {
        imports = [
          # add custom nixos modules here, as you create them!
        ];
      };

      nixosConfigurations = import ./hosts.nix { inherit inputs; };
    };
}
