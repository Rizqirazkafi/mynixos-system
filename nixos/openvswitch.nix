{ inputs, config, lib, pkgs, pkgs-unstable, ... }: {

  virtualisation.vswitch = {
    enable = true;
    package = pkgs.openvswitch;

  };

}
