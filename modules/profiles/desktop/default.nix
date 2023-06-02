{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myProfiles.desktop;

in {
  options.myProfiles.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-utils			# for opening default programs when clicking links
    ];

    # system.autoUpgrade = {
    #   enable = true;
    #   flake = "git+file:/home/${config.user.name}/.flake";
    #   # flags = [
    #   #   "--update-input" "nixpkgs"
    #   #   "--update-input" "home-manager"
    #   #   "--commit-lock-file"
    #   # ];
    # };

    myPrograms = {
      # alacritty.enable = true;
      brave.enable = true;
      discord.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      git.enable = true;
      gpg.enable = true;
      gping.enable = true;
      helix.enable = true;
      imv.enable = true;
      keepassxc.enable = true;
      kitty.enable = true;
      lf.enable = true;
      ncmpc.enable = true;
      nx.enable = true;
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
