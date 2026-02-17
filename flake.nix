{
  description = "System configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, fenix, ... }@inputs: {
    nixosConfigurations = let 
      hosts = [ "dubbo" "ifs" ];
      config = hostname: {
        ${hostname} = nixpkgs.lib.nixosSystem {
          modules = [
            ./hardware/${hostname}.nix
            (import ./system.nix { fenix = fenix; hostname = hostname; })
            home-manager.nixosModules.home-manager { home-manager = import ./user.nix { hostname = hostname; }; }
          ];
        };
      };
    in nixpkgs.lib.mergeAttrsList (map config hosts); 
  };
}
