#NoteBook FanControl
{ config, pkgs, ... }:


let
  myUser = "rizqirazkafi"; #adjust this to your username
  command = "bin/nbfc_service --config-file '/etc/nbfc/nbfc.json'";
in

{

# Needed for both flakes and fetchFromGitHub:
systemd.services.nbfc_service = {
  enable = true;
  description = "NoteBook FanControl service";
  serviceConfig.Type = "simple"; #related upstream config: https://github.com/nbfc-linux/nbfc-linux/blob/main/etc/systemd/system/nbfc_service.service.in
  path = [ pkgs.kmod ];
  script = "/home/${myUser}/.nix-profile/${command}"; #for flake
  wantedBy = [ "multi-user.target" ];
};

}
