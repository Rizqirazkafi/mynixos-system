{ config, libs, pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins = prev.vimPlugins // {
        own-flutter-tools = prev.vimUtils.buildVimPlugin {
          name = "own-flutter-tools";
          src = inputs.own-flutter-tools;
        };
      };
    })
  ];
}
