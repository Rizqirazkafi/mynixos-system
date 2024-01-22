{ config, lib, pkgs, ... }:
{
  fileSystems."/home/rizqirazkafi/winssd" =
    {
      device = "/dev/nvme0n1p3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };
  fileSystems."/home/rizqirazkafi/secondssd" =
    {
      device = "/dev/nvme1n1p3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };
}
