{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true; # wayland compatibility
    powerManagement.enable = true;
    prime = { # TODO these are for IFS specifically
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
  boot.blacklistedKernelModules = [ "nouveau" ];
}
