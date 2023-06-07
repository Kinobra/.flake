{ config, lib, ... }:

with lib;
let cfg = config.myServices.nix;

in {
  options.myServices.nix = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    {
      nix.settings = {
        substituters = [
          "https://cache.nixos.org/"
        ];
        experimental-features = [ "nix-command" "flakes" ];
        sandbox = true;
      };
    }
    (mkIf cfg.enable {
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
        settings = let
          users = [ "@wheel" ];
        in {
          # keep-outputs = true;
          # keep-derivations = true;
          auto-optimise-store = true;
          allowed-users = users;
          trusted-users = users;
        };
      };
    })
  ];
}
