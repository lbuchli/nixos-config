{ hostname, noctalia }: let username = "lukas"; in {

  useUserPackages = true;
  users.${username} = { config, lib, pkgs, ... }: {
    imports = [
      noctalia.homeModules.default
    ];

    home.username = username;
    home.homeDirectory = "/home/${username}";
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
      typst
      tinymist # typst lsp
    ];

    home = {
      sessionVariables = {
        DOOMDIR = "${config.xdg.configHome}/doom";
        DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      };
      sessionPath = [
        "${config.xdg.configHome}/emacs/bin"
        "$HOME/.cargo/bin"
      ];
    };

    # link files from this repo to ~/.config/
    xdg.configFile = let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      inherit (lib) flatten flip pipe map mergeAttrsList;
      link = name: {
        ${name} = {
          source = config.lib.file.mkOutOfStoreSymlink "${./.}/configs/${name}";
          recursive = true;
        };
      };
    in mergeAttrsList ([{
      "emacs" = {
        source = builtins.fetchGit {
          url = "https://github.com/hlissner/doom-emacs";
          rev = "74d1b871b75fb19feefa2722628aecfe0b828e79"; # 18.02.2026
        };
        onChange = "${pkgs.writeShellScript "doom-change" ''
          export PATH="/etc/profiles/per-user/lukas/bin":$PATH # emacs location
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync -u
          fi
        ''}";
      };
    }] ++ map link [ "doom" "niri" ]);

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        sha256 = "sha256:13ghh3ma9rjanqa48b558x9kcz6h983rnc3l8j5my7lv85mc434w";
      }))
    ]; 

    programs.noctalia-shell = import ./configs/niri-noctalia.nix;
    # wallpaper from https://unsplash.com/photos/aerial-view-of-pine-trees-in-mist-OYFHT4X5isg
    home.file."wallpaper.jpg".source = config.lib.file.mkOutOfStoreSymlink ./images/wallpaper.jpg;
    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/${username}/wallpaper.jpg";
      };
    };

    programs.bash.enable = false;
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };

      initContent = ''
      eval $(starship init zsh)
      '';

      shellAliases = {
        ll = "ls -alh";
        nixos-switch = "sudo nixos-rebuild --flake /home/lukas/nixos-config#${hostname} switch";
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

      settings = {
        user.name = "Lukas Buchli";
        user.email = "lukas.buchli@ost.ch";
        core.editor = "vim";
      };
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

