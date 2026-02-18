{
  description = "System configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, fenix, noctalia, ... }@inputs: {
    nixosConfigurations = let 
      hosts = [ "dubbo" "ifs" ];
      config = hostname: {
        ${hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit hostname; inherit (inputs) fenix; };
          modules = [
            ./hardware/${hostname}.nix
            ./system.nix
            home-manager.nixosModules.home-manager {
              home-manager = import ./user.nix { inherit hostname; inherit (inputs) noctalia; };
            }
          ];
        };
      };
    in nixpkgs.lib.mergeAttrsList (map config hosts); 
  };
}
