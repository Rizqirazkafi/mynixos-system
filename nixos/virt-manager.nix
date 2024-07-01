{ config, lib, pkgs, ... }: {
  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" ];
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];

      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
