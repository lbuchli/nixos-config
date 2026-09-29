let username = "demo"; in { config, lib, pkgs, ... }: {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.packages = with pkgs; [
    nano
  ];

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # for codium to work on wayland
    };
    sessionPath = [
    ];
  };

  # link files from this repo to ~/.config/
  xdg.configFile = let
    inherit (config.lib.file) mkOutOfStoreSymlink;
    inherit (lib) flatten flip pipe map mergeAttrsList;
    link = name: {
      ${name} = {
        source = config.lib.file.mkOutOfStoreSymlink "${../configs}/${name}";
        recursive = true;
      };
    };
  in mergeAttrsList (map link [ ]);

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
      user.name = "Demo Dominic";
      user.email = "demodominic@gmail.com";
      core.editor = "nano";
      init.defaultBranch = "main";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        mkhl.direnv
        haskell.haskell
      ];
      userSettings = {
        "editor.fontSize" = 15;
        "window.zoomLevel" = 2;
      };
    };
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.05";
}
