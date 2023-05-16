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
        # permitRootLogin = "no";
        passwordAuthentication = false;
      };
    };
    users.users."${config.user.name}".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5sKJwoWWgrslkvtCMARjtY/IM9V7HHVX3HgsSvhqP0 sntx.htqjd@simplelogin.com" # nixos
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtlYx+hniAAYO3dv6yj2DKdtJOcHncUEqUrkBABB8yZ sntx.htqjd@simplelogin.com" # minerva
    ];
  };
}
