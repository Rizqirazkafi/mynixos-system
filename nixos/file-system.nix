{ config, lib, pkgs, ... }: {
  fileSystems."/home/rizqirazkafi/1tb" = {
    device = "/dev/disk/by-uuid/329C4F7D1D010F75";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };
}
