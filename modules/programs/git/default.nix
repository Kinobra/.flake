{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.git;

in {
  options.myPrograms.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.git = {
      enable = true;
      userName  = "sntx";
      userEmail = "sntx.htqjd@simplelogin.com";
      extraConfig = {
        user = {
          signingkey = "0809A27405DE37A16884FD78071E9A0190AAB7E9";
        };
        pull = {
          rebase = false;
        };
        init = {
          defaultBranch = "main";
        };
        commit = {
          gpgsign = true;
        };
        core = {
          sshCommand = "ssh -i /home/${config.user.name}/.ssh/sourcehut";
          # sshCommand = "ssh -i /home/sntx/.ssh/gitlab_uni";
        };
      };
    };
    home.programs.gitui = {
      enable = true;
      keyConfig = ''
        (
          move_left:  Some(( code: Char('h'), modifiers: ( bits: 0,),)),
          move_right: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
          move_up:    Some(( code: Char('k'), modifiers: ( bits: 0,),)),
          move_down:  Some(( code: Char('j'), modifiers: ( bits: 0,),)),

          stash_open: Some(( code: Char('l'), modifiers: ( bits: 0,),)),

          open_help:  Some(( code: F(1)     , modifiers: ( bits: 0,),)),
        )
      '';
    };
  };
}
