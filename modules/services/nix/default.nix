{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.nix;

in {
  options.myServices.nix = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 32d";
      };
      optimise = {
        automatic = true;
        dates = [ "daily" ];
      };
      settings = {
        # keep-outputs = true;
        # keep-derivations = true;
        auto-optimise-store = true;
        # cores = 32;
        # max-jobs = 32;
        sandbox = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
  };
}
