{
  useGlobalPkgs = true;
  useUserPackages = true;
  users.lukas = { config, pkgs, ... }: {
    home.username = "lukas";
    home.homeDirectory = "/home/lukas";
    home.packages = [  ];
    programs.zsh.enable = true;
  
    programs.emacs = {
    enable = true;
    package = pkgs.emacs30;
    };
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}

