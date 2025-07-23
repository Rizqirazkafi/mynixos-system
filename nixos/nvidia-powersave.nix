{ config, lib, pkgs, ... }: {
  hardware.graphics = {
    enable = true;
    # driSupport = true;
  };
  services.xserver.videoDrivers = [ "modesetting nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA 
    intelBusId = "PCI:0:2:0";
  };
  specialisation = {
    gpu-task.configuration = {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics = { enable = true; };
      hardware.nvidia = {
        open = false;
        prime.sync.enable = lib.mkForce true;
        prime = {
          # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
          nvidiaBusId = "PCI:1:0:0";

          # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA 
          intelBusId = "PCI:0:2:0";

        };
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };
}
