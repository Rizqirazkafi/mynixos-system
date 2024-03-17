{ config, lib, pkgs, ... }: {
  fileSystems."/home/rizqirazkafi/winssd" = {
    device = "/dev/disk/by-uuid/AC2CC3AF2CC372BE";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };
  fileSystems."/home/rizqirazkafi/secondssd" = {
    device = "/dev/disk/by-uuid/AA88175D8817277B";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };
}
