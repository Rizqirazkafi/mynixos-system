{ config, lib, pkgs, ... }: {
  programs.virt-manager.enable = true;
  # use virsh net-start default to enable virbr0
  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" ];
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtio-win ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
