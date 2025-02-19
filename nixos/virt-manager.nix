{ config, lib, pkgs, ... }: {
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" ];
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        vhostUserPackages = [ pkgs.virtio-win ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
