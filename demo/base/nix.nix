{ hostVars, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = hostVars.stateVersion;
}
