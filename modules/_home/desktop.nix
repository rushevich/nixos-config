{ config, lib, pkgs, ... }:

let
  screenshot-region = pkgs.writeShellApplication {
    name = "screenshot-region";
    runtimeInputs = with pkgs; [ grim slurp satty wl-clipboard coreutils ];
    text = ''
      dir="$HOME/Pictures/Screenshots"
      mkdir -p "$dir"
      geom=$(slurp) || exit 0
      grim -g "$geom" - | satty --filename -
    '';
  };
in
{
  home = {
    packages = with pkgs; [
      grim
      slurp
      wl-clipboard
      screenshot-region
    ];
  };

  programs.satty = {
    enable = true;
    settings = {
      general = {
        fullscreen = true;
        early-exit = true;
        copy-command = "wl-copy";
        output-filename = "${config.home.homeDirectory}/Pictures/screenshots/satty-%Y%m%d-%H%M%S.png";
      };
    };
  };
}
