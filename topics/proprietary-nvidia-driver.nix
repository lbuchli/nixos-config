{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true; # wayland compatibility
    powerManagement.enable = true;
  };
  boot.blacklistedKernelModules = [ "nouveau" ];
}

