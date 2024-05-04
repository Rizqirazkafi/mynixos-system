{ pkgs, config, ... }:

{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    font = {
      normal = {
        family = "Terminess Nerd Font";
        style = "Regular";
      };
      bold = {
        family = "Terminess Nerd Font";
        style = "Bold";
      };
      italic = {
        family = "Terminess Nerd Font";
        style = "Italic";
      };
      bold_italic = {
        family = "Terminess Nerd Font";
        style = "Bold Italic";
      };
    };
  };
}
