{ config, lib, pkgs, ... }: {
  hardware.graphics.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    nvidiaPersistenced = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  boot.blacklistedKernelModules = [ "nouveau" ];

  specialisation.on-the-go.configuration = {
    system.nixos.tags = [ "on-the-go" ];
    services.xserver.videoDrivers = [ "intel" ];
    hardware.nvidia.prime = {
#      offload = {
#        enable = lib.mkForce true;
#        enableOffloadCmd = lib.mkForce true;
#      };
      sync.enable = lib.mkForce true;
    };
  };
}
