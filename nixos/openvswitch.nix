{ inputs, config, lib, pkgs, pkgs-unstable, ... }: {

  networking.vswitches.vs1 = {
    interfaces = [{
      name = "enp2s0";
      type = "internal";
    }];
  };

}
