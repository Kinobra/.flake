{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.nushell;

in {
  options.myPrograms.nushell = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      # du-dust
      trashy
      # unzip
      # ripgrep
      # skim
    ];

    home.programs.nushell = {
      enable = true;
      extraConfig = ''
        def update_title [] {
          mut home = ""
          try {
              if $nu.os-info.name == "windows" {
                  $home = $env.USERPROFILE
              } else {
                  $home = $env.HOME
              }
          }

          let dir = ([
              ($env.PWD | str substring 0..($home | str length) | str replace --string $home "~"),
              ($env.PWD | str substring ($home | str length)..)
          ] | str join)

          print --no-newline $"(ansi title)($dir)(ansi st)"
        }

        let-env config = {
          show_banner: false
          shell_integration: false
          rm: {
            always_trash: false # always act as if -t was given. Can be overridden with -p
          }
          # edit_mode: vi
          hooks: {
            env_change: {
              PWD: {|| update_title}
            }
          }
        }
      '';
      extraEnv = ''
        def get_prompt_indicator [] {
          [ (if (is-admin) { ansi red_bold } else { ansi green_bold })
            "ヌ"
            (ansi reset)
          ] | str join
        }

        def get_right_prompt [] {
          mut nix_shell = ""

          try {
            $nix_shell = ($env | get IN_NIX_SHELL)
          }

          if not ($nix_shell | is-empty) {
            [ "with \'" $nix_shell "\' nix shell" ] | str join
          } else { "" }
        }

        let-env PROMPT_COMMAND = {|| "" }
        let-env PROMPT_INDICATOR = {|| get_prompt_indicator }
        let-env PROMPT_COMMAND_RIGHT = {|| get_right_prompt }

        # tar
        alias tarJ = tar --remove-files --use-compress-program='xz -T0' -cvf
        #new-file-name #folder-to-be-compressed

        # cat -> bat
        alias cat = bat

        # trash
        alias tr = trash
      '';
    };
    home.sessionVariables = {
      NIX_BUILD_SHELL="nu";
    };
  };
}
