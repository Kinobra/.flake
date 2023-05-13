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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEx240I+HTAgTFYqyUzQr4vn2TR4wr1XAGT1h2mf0vZg sntx.htqjd@simplelogin.com" # minerva
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5sKJwoWWgrslkvtCMARjtY/IM9V7HHVX3HgsSvhqP0 sntx.htqjd@simplelogin.com" # nixos
    ];
  };
}
