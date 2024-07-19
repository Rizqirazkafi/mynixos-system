{ config, lib, pkgs, pkgs-unstable, ... }: {
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" ];
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
