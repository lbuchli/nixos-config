{
  useUserPackages = true;
  users.lukas = { config, lib, pkgs, ... }: {
    home.username = "lukas";
    home.homeDirectory = "/home/lukas";
    home.packages = with pkgs; [
      #emacs dependencies
      ripgrep
      coreutils
      fd
      clang
      cmake
      gnumake
      pkg-config
      pandoc
      tinymist # typst lsp
    ];

    xdg.configFile = let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      inherit (lib) flatten flip pipe map mergeAttrsList;
      link = name: {
        ${name} = {
          source = config.lib.file.mkOutOfStoreSymlink "${./.}/dotfiles/${name}";
          recursive = true;
        };
      };
    in  (flip pipe) [(map link) mergeAttrsList] [
      "doom"
    ];

    home.sessionPath = [
      "\${xdg.configHome}/emacs/bin"
      "$HOME/.cargo/bin"
    ];

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        sha256 = "sha256:1qcgk5k2cm24z091a9fzijbs6ablzyy08dj1qczqg9zz5hrmhm88";
      }))
    ]; 

    programs.bash.enable = false;
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          #{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
          #{ name = "powerlevel10k-config"; file = ./dotfiles/.p10k.zsh; }
        ];
      };

      initContent = ''
      eval $(starship init zsh)
      '';

      shellAliases = {
        ll = "ls -alh";
        nixos-switch = "sudo nixos-rebuild --flake /home/lukas/nixos-config switch";
      };

    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        command_timeout = 1300;
        scan_timeout = 50;
        format = "$all$nix_shell$nodejs$lua$golang$rust$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
        character = {
          success_symbol = "[](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.git = {
      enable = true;
      lfs.enable = true;

      userName = "Lukas Buchli";
      userEmail = "lukas.buchli@ost.ch";

      extraConfig.core.editor = "vim";
    };


    programs.emacs = {
      enable = true;
    };
  
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}

