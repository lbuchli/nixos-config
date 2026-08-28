{
  description = "System configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    doom-emacs = {
      url = "github:doomemacs/core?submodules=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, fenix, emacs-overlay, noctalia, ... }@inputs: {
    nixosConfigurations = let 
      hosts = [ "dubbo" "ifs" ];
      config = hostname: let
        settings = import ./settings.nix { inherit hostname; };
      in {
        ${hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit hostname; inherit settings; inherit (inputs) fenix; };
          modules = [
            ./hardware/${hostname}.nix
            ./system.nix
            home-manager.nixosModules.home-manager {
              home-manager = import ./user.nix { inherit hostname; inherit settings; inherit (inputs) noctalia emacs-overlay doom-emacs; };
            }
          ] ++ nixpkgs.lib.optional settings.hasProprietaryNvidiaDrivers ./topics/proprietary-nvidia-driver.nix;
        };
      };
    in nixpkgs.lib.mergeAttrsList (map config hosts); 
  };
}
