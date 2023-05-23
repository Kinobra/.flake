{ config, options, lib, pkgs, ... }:

with lib;

{
  options = {
    user = lib.mkOption { };

    home = {
      sway = lib.mkOption { description = "Sway config options"; };

      dconf = lib.mkOption { };
      file = lib.mkOption { description = "Files to place in $HOME"; };
      packages = lib.mkOption { description = "User-level installed packages"; };
      programs = lib.mkOption { description = "Programs managed directly from home-manager"; };
      services = lib.mkOption { description = "Services managed directly from home-manager"; };
      sessionVariables = lib.mkOption { };
      pointerCursor = lib.mkOption { description = "Cursor configuration. Set to null to disable."; };

      configFile = lib.mkOption { description = "Files to place in $XDG_CONFIG_HOME"; };
      dataFile = lib.mkOption { description = "Files to place in $XDG_DATA_HOME"; };
    };

    theme = lib.mkOption { };
  };

  config = {

    user = {
      name = "sntx";
      # name = let name = builtins.getEnv "USER";
      description = "sntx";
      group = "sntx";
      extraGroups = [ "wheel" ];
      # extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      isNormalUser = true;
      # in if elem name [ "" "root" ] then "sntx" else name;
      # uid = 1000;
      # passwordFile = "/var/secrets/${config.user.name}-password";
      shell = pkgs.nushell;
    };

    environment.systemPackages = with pkgs; [
      nushell
    ];
    # programs.nushell.enable = true;
    # users.mutableUsers = false;
    # users.groups."sntx".gid = 1000;

    # users.users.localtimed.group = "localtimed";
    # users.groups.localtimed = { };

    # security.pam.services.${config.user.name}.enableGnomeKeyring = true;
    # services.gnome.gnome-keyring.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      /* Let Home Manager install and manage itself */
      # programs.home-manager.enable = true;

      users.${config.user.name} = {
        home = {
          stateVersion = config.system.stateVersion;
        };

        wayland.windowManager.sway = mkAliasDefinitions options.home.sway;

        dconf = mkAliasDefinitions options.home.dconf;
        home.file = mkAliasDefinitions options.home.file;
        home.packages = mkAliasDefinitions options.home.packages;
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;
        home.sessionVariables = mkAliasDefinitions options.home.sessionVariables;
        home.pointerCursor = mkAliasDefinitions options.home.pointerCursor;

        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.groups.${config.user.group} = {};
    users.users.${config.user.name} = mkAliasDefinitions options.user;

    # nix.settings = let users = [ "root" config.user.name ];
    # in {
    #   trusted-users = users;
    #   allowed-users = users;
    # };

    # env.PATH = [ "$XDG_CONFIG_HOME/dotfiles/bin" "$XDG_BIN_HOME" "$PATH" ];

    # environment.extraInit = concatStringsSep "\n"
    #   (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}
