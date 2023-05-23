{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myProfiles.desktop-minimal;

in {
  options.myProfiles.desktop-minimal = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-utils			# for opening default programs when clicking links
    ];

    system.autoUpgrade = {
      enable = true;
      flake = "git+file:/home/${config.user.name}/.flake";
      # flags = [
      #   "--update-input" "nixpkgs"
      #   "--update-input" "home-manager"
      #   "--commit-lock-file"
      # ];
    };

    myPrograms = {
      discord.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      git.enable = true;
      gpg.enable = true;
      helix.enable = true;
      imv.enable = true;
      keepassxc.enable = true;

      # kitty.enable = true;
      alacritty.enable = true;

      lf.enable = true;
      ncmpc.enable = true;
      mpv.enable = true;
      nushell.enable = true;
      signal.enable = true;
      yt-dlp.enable = true;
      zathura.enable = true;
    };

    myServices = {
      nix.enable = true;
      syncthing.enable = true;
    };
  };
}
