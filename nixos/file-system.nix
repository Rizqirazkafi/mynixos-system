{ config, lib, pkgs, ... }: {
  fileSystems."/home/rizqirazkafi/1tb" = {
    device = "/dev/disk/by-uuid/01DBFCA1A19D33D0";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };
}
