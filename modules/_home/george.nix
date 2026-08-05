{ config, pkgs, lib, ... }: {
  imports = [ ./emacs.nix ./git.nix ./dev.nix ./vesktop.nix ./cursors.nix ./zsh.nix ./desktop.nix ];
  home = {
    username = "george";
    homeDirectory = "/home/george";
    stateVersion = "26.05";
  };
}
