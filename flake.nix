{
  description = "An example flake following the Synaptic Standard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

      nixosConfigurations = import ./hosts.nix { inherit inputs; };
    };
}
