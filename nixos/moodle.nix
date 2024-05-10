{ inputs, config, pkgs, ... }:

{
  services.moodle = {
    enable = true;
    initialPassword = "merdeka45hebat";
  };
}
