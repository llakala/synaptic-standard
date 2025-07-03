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

    # any custom modules we defined are collected into this one module
    inputs.self.nixosModules.default
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
    specialArgs = specialArgs // { hostVars.username = "me"; };

    modules = resolveAndFilter (base ++ desktop ++ [ ./hosts/laptop ]);
  };

  desktop = lib.nixosSystem {
    specialArgs = specialArgs // { hostVars.username = "me"; };

    modules = resolveAndFilter (base ++ gaming ++ desktop ++ [ ./hosts/desktop ]);
  };

  server = lib.nixosSystem {
    specialArgs = specialArgs // { hostVars.username = "me"; };

    modules = resolveAndFilter (base ++ [ ./hosts/server ]);
  };
}
