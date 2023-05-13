{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.openssh;

in {
  options.myServices.openssh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        permitRootLogin = "yes";
        passwordAuthentication = false;
      };
    };
    users.users."${config.user.name}".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCcOm5bv/HZtyaavJ0xBFvZJ6fLfuUxhtFj1UU7YXfi" # nixos
    ];
  };
}
