{ inputs }:

let
  lib = inputs.nixpkgs.lib;

  # Simple wrapper around `lib.filesystem.listFilesRecursive`. Instead of taking
  # a single folder and importing it recursively, it now takes a list of files,
  # folders, and modules. It'll import any folders recursively, but files won't
  # be recursive at all!
  recursivelyImport = import ./recursivelyImport.nix { inherit lib; };

  specialArgs = {
    inherit inputs;
    baseVars.username = "me";
  };
in
{
  laptop = lib.nixosSystem {
    specialArgs = specialArgs // {
      hostVars = {
        hostname = "laptop";
        stateVersion = "24.11";
      };
    };

    modules = recursivelyImport [
      ./base
      ./workstation
      ./hosts/laptop
    ];
  };

  desktop = lib.nixosSystem {
    specialArgs = specialArgs // {
      hostVars = {
        hostname = "desktop";
        stateVersion = "25.05";
      };
    };

    modules = recursivelyImport [
      ./base
      ./workstation
      ./hosts/desktop
    ];
  };

  server = lib.nixosSystem {
    specialArgs = specialArgs // {
      hostVars = {
        hostname = "desktop";
        stateVersion = "24.11";
      };
    };

    modules = recursivelyImport [
      ./base
      ./hosts/server
    ];
  };
}
