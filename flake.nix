{
  # Description, write anything or even nothing
  description = "sntx's NixOS flake";

  # Input config, or package repos
  inputs = {
    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my custom programs
    nx-fetch.url = "sourcehut:~sntx/nx-fetch";
    nx-gen.url = "sourcehut:~sntx/nx-gen";
    nx-pkgs.url = "sourcehut:~sntx/nx-pkgs";
  };

  # Output config, or config for NixOS system
  outputs = { nixpkgs, home-manager, nx-fetch, nx-gen, nx-pkgs, ... }@inputs: {

    # Define a devshell for working with the flake
    devShells = let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in {
      "${system}".default = pkgs.mkShell {
        packages = with pkgs; [ nil ];
      };
    };

    # You can define many systems in one Flake file.
    # NixOS will choose one based on your hostname.

    # Personal list of possible secondary system names:
    # Juno, Vesta, Minerva, Ceres, Diana, Venus,
    # Mars, Mercurius, Iovis, Neptunus, Vulcanus, Apollo

    # Define a server called "ceres"
    nixosConfigurations."ceres" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          networking.hostName = "ceres";
          networking.domain = "valkyrja.eu";
          myProfiles.server.enable = true;
        }
      ];
    };

    # Define a laptop called "minerva"
    nixosConfigurations."minerva" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          nixpkgs.config.allowUnfree = true;

          networking.hostName = "minerva";
          myDesktops.sway.enable = true;
          myProfiles = {
            desktop.enable = true;
          };
          myThemes."abyss".enable = true;

          myPrograms = {
            light.enable = true;
          };
        }
      ];
    };

    # Define a system called "nixos"
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          nixpkgs.config.allowUnfree = true;

          networking.hostName = "nixos";
          myDesktops.sway.enable = true;
          myProfiles = {
            desktop.enable = true;
            gaming.enable = true;
            virtualisation.enable = true;
          };
          myThemes."abyss".enable = true;

          myPrograms = {
            helvum.enable = true;
          };
          myServices = {
            easyeffects.enable = true;
          };
        }
      ];
    };
  };
}
