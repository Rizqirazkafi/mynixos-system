{ config, lib, pkgs, ... }: {
  fileSystems."/home/rizqirazkafi/secondhdd" = {
    device = "/dev/disk/by-uuid/c95a382e-a747-4e58-86ae-01856d11285c";
    fsType = "ext4";
  };

}
