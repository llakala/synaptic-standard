{ inputs }:

let
  lib = inputs.nixpkgs.lib;

  # Simple wrapper around `lib.filesystem.listFilesRecursive`. Instead of taking
  # a single folder and importing it recursively, it now takes a list of files,
  # folders, and modules. It'll import any folders recursively, but files won't
  # be recursive at all!
  resolveAndFilter = import ./resolveAndFilter.nix { inherit lib; };

  specialArgs = {
    inherit inputs;
  };

  base = [
    ./base
  ];
  gaming = [
    ./optional/gaming
  ];
  desktop = [
    ./optional/gnome.nix
  ];

in
{
  laptop = lib.nixosSystem {
    inherit specialArgs;

    modules = resolveAndFilter (base ++ desktop ++ [ ./hosts/laptop ]);
  };

  desktop = lib.nixosSystem {
    inherit specialArgs;

    modules = resolveAndFilter (base ++ gaming ++ desktop ++ [ ./hosts/desktop ]);
  };

  server = lib.nixosSystem {
    inherit specialArgs;

    modules = resolveAndFilter (base ++ [ ./hosts/server ]);
  };
}
