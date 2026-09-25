{ hostname, settings, noctalia, emacs-overlay, doom-emacs }: let username = "lukas"; in {

  useUserPackages = true;
  users.${username} = { config, lib, pkgs, ... }: {
    imports = [
      noctalia.homeModules.default
    ];

    nixpkgs.overlays = [ emacs-overlay.overlays.default ];

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
        NIXOS_OZONE_WL = "1"; # for codium to work on wayland
      };
      sessionPath = [
        "${config.xdg.configHome}/emacs/bin"
        "$HOME/.cargo/bin"
      ];
    };

    dconf.settings = {
    } // pkgs.lib.optionalAttrs settings.hasVirtualization {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
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
    in mergeAttrsList (/* [{ # does not work anymore :( TODO find a solution. Right now: clone manually (git clone --depth 1 https://github.com/doomemacs/core ~/.config/emacs / ~/.config/emacs/bin/doom install)
      "emacs" = {
        source = doom-emacs;
        onChange = ''
          export PATH="/etc/profiles/per-user/lukas/bin":$PATH # emacs location
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install --force
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u --force
          fi
        '';
      };
    }] ++ */ map link [ "doom" "niri" "zed" ]);

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
        init.defaultBranch = "main";
      };
    };

    programs.zed-editor = {
      enable = true;
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs-unstable-pgtk;
    };

    services.emacs = {
      enable = true;
      defaultEditor = true;
      package = pkgs.emacs-unstable-pgtk;
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        james-yu.latex-workshop
      ];
    };

    programs.opencode = {
      enable = true;
      settings = { # schema: https://opencode.ai/docs/config/
        provider = {
          llmhub = {
            options = {
              baseURL = "https://api.llmhub.infs.ai/v1";
              models = [ "best-code" "best-chat" ];
              apiKey = "{file:~/nixos-secrets/llmhub}";
            };
            models = {
              "best-code" = { name = "best-code"; };
              "best-chat" = { name = "best-chat"; };
            };
          };
          local-ollama = {
            options = {
              baseURL = "http://localhost:11434/v1";
              models = [ "qwen3.6" ];
            };
            models = {
              "qwen3.6" = { name = "qwen3.6"; };
            };
          };
        };
        autoupdate = false;
        permission = {
          edit = "ask";
          bash = "ask";
        };
      };
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

