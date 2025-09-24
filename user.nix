{
  useUserPackages = true;
  users.lukas = { config, pkgs, ... }: {
    home.username = "lukas";
    home.homeDirectory = "/home/lukas";
    home.packages = [  
    ];

    home.sessionPath = [
      "~/.config/emacs/bin"
    ];

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        sha256 = "sha256:1qcgk5k2cm24z091a9fzijbs6ablzyy08dj1qczqg9zz5hrmhm88";
      }))
    ]; 


    programs.zsh = { 
      enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };

      shellAliases = {
        ll = "ls -alh";
        nixos-switch = "sudo nixos-rebuild --flake /home/lukas/nixos-config switch";
      };
    };
    
    programs.git = {
      enable = true;
      userName = "Lukas Buchli";
      userEmail = "lukas.buchli@ost.ch";
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

