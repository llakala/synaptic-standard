{ lib }:

let
  recurseIntoFolders =
    elem:
    if lib.isPath elem && lib.pathIsDirectory elem then
      lib.filesystem.listFilesRecursive elem
    else
      # If it's not a folder, return it unchanged. This handles single-files and
      # literal modules (written with {} syntax)
      [ elem ];
in
  paths:
    builtins.filter
    # filter the files for `.nix` files. if it's not a file, it can stay.
    # We make sure to run toString on the path, to prevent copying to the store
    (path: !builtins.isPath path || lib.hasSuffix ".nix" (toString path))
    # Expand any folders into all the files within them.
    (builtins.concatMap recurseIntoFolders paths)
