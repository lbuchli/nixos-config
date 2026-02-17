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
    # Please replace nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./hardware-configuration.nix
        (import ./system.nix { fenix = fenix; })
        home-manager.nixosModules.home-manager { home-manager = import ./user.nix; }
      ];
    };
  };
}
