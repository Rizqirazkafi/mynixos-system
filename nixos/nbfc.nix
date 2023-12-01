#NoteBook FanControl
{ config, pkgs, ... }:


let
  myUser = "rizqirazkafi"; #adjust this to your username
  command = "bin/nbfc_service --config-file '/etc/nbfc/nbfc.json'";
in

{

# If you don't use flakes:
#environment.systemPackages = with pkgs; [
#  nix-prefetch-github
#  nbfc
#];

# Needed for both flakes and fetchFromGitHub:
systemd.services.nbfc_service = {
  enable = true;
  description = "NoteBook FanControl service";
  serviceConfig.Type = "simple"; #related upstream config: https://github.com/nbfc-linux/nbfc-linux/blob/main/etc/systemd/system/nbfc_service.service.in
  path = [ pkgs.kmod ];
  # script = let package = nbfc.packages.${pkgs.system}.nbfc; in "${package}/${command}"; #for fetchFromGitHub
  script = "/home/${myUser}/.nix-profile/${command}"; #for flake
  wantedBy = [ "multi-user.target" ];
};

}
