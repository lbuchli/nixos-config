{
  useGlobalPkgs = true;
  useUserPackages = true;
  users.lukas = { config, pkgs, ... }: {
    home.username = "lukas";
    home.homeDirectory = "/home/lukas";
    home.packages = [  ];
    programs.zsh.enable = true;
    
    programs.git = {
      enable = true;
      userName = "Lukas Buchli";
      userEmail = "lukas.buchli@ost.ch";
    };
  
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30;
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

