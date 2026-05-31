{ config, lib, pkgs, ... }: {
  fileSystems."/home/rizqirazkafi/1tb" = {
    device = "/dev/disk/by-uuid/01DBFCA1A19D33D0";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };

  fileSystems."/home/rizqirazkafi/DockerSystem" = {
    device = "/dev/disk/by-uuid/3ca03ee2-c8e7-4160-8d95-579f1809ba57";
    fsType = "ext4";
    options = [ "defaults" "user" "rw" ];
  };
}
