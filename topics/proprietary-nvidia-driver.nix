{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
  ];
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

