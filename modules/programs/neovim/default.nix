{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.neovim;

in {
  options.myPrograms.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lf					# Terminal file manager
      # fzf					# A command-line fuzzy finder
      # silver-searcher			# A code-searching tool similar to ack, but faster
      # skim				# Fuzzy Finder in rust!
      # ripgrep				# Ripgrep recursively searches directories for a regex pattern while respecting your gitignore
      toilet				# Display large colourful characters in text mode
    ];

    home.programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      defaultEditor = true;
      withRuby = true;
      withPython3 = true;
      withNodeJs = true;
      extraLuaConfig = ''
        require('config/settings')
        require('config/autocmd')
        require('config/keybinds')
        require('config/scripts')

        require('plugins/better-escape')
        require('plugins/coc')
        require('plugins/dashboard-nvim')
        require('plugins/floaterm')

        require('colors/init')
        require('colors/alpha-black')
      '';
      coc = {
        enable = true;
        settings = {
          languageserver = {
            godot = {
              host = "127.0.0.1";
              filetypes = [ "gd" "gdscript" "gdscript3" ];
              port = 6005;
            };
          };
        };
      };
      plugins = with pkgs.vimPlugins; [
        ### CoC
        coc-css
        # coc-git
        # coc-java
        coc-json
        coc-markdownlint
        # coc-prettier
        coc-pyright
        coc-rust-analyzer
        coc-sh
        coc-yaml
        coc-toml
        coc-html
        # coc-docker
        # coc-sqlfluff
        # coc-spell-checker
        ### Normal Plugins
        vim-nix				# Nix language support for vim
        ron-vim				# RON syntax highlighting for Vim
        dashboard-nvim			# A Doom Emacs like dashboard
        lf-vim				# Lf integration in vim and neovim
        vim-floaterm			# Terminal manager for (neo)vim
        # fzf-vim				# Fuffy finder in vim
        vim-airline			# A better bottom status bar
        vim-sleuth			# Automatically adjust indentation to the current file
        better-escape-nvim		# Escape insert mode fast (by typing jk fast)
        vim-commentary			# Commenting stuff out easily
        delimitMate			# Insertion of matching pairs
        neoformat				# Format code using formatters
        # orgmode				# Org-Mode in vim
        vim-unimpaired			# unimpaired.vim: Pairs of handy bracket mappings
        nvim-colorizer-lua		# Add colorizer to color codes
        # vim-wakatime			# Track coding stats with wakatime
      ];
    };

    home.sessionVariables = {
      EDITOR="nvim";
    };

    home.configFile."nvim/lua".source = ./lua;
  };
}
