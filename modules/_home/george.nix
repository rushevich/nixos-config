{ config, pkgs, lib, ... }: {
  imports = [ ./emacs.nix ./git.nix ./dev.nix ./vesktop.nix ./cursors.nix ];
  home.username = "george";
  home.homeDirectory = "/home/george";
  home.stateVersion = "26.05";

  # user-level config goes here
}
