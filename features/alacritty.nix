{ pkgs, config, nixgl, lib, ... }:

{
  programs.alacritty.enable = true;
  # programs.alacritty = { package = config.lib.nixGL.wrap pkgs.alacritty; };
  programs.alacritty.settings = { window.opacity = lib.mkForce 0.75; };
}
