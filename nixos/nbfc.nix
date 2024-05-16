# NoteBook FanControl
{ config, pkgs, inputs, ... }:

let
  myUser = "rizqirazkafi"; # adjust this to your username
  command =
    "bin/nbfc_service --config-file '/home/${myUser}/.config/nbfc.json'";

in {
  environment.systemPackages = with pkgs;
    [ inputs.nbfc-linux.packages.x86_64-linux.default ];

  # Needed for both flakes and fetchFromGitHub:
  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    serviceConfig.Type =
      "simple"; # related upstream config: https://github.com/nbfc-linux/nbfc-linux/blob/main/etc/systemd/system/nbfc_service.service.in
    path = [ pkgs.kmod ];
    script = "${inputs.nbfc-linux.packages.x86_64-linux.default}/${command}";
    wantedBy = [ "multi-user.target" ];
  };

}
