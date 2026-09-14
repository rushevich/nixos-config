{
  config,
  pkgs,
  lib,
  ...
}:
let
  myEmacs = pkgs.emacs31-pgtk.pkgs.withPackages (epkgs: [ epkgs.notmuch ]);
in
{
  home.packages = with pkgs; [
    myEmacs
    ripgrep
    fd
    git
  ];

  home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    		if [ ! -d "${config.home.homeDirectory}/dotfiles" ]; then
    			${pkgs.git}/bin/git clone https://github.com/rushevich/general-dotfiles "${config.home.homeDirectory}/dotfiles"
    				fi
    				'';
  xdg.configFile."emacs".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/emacs/.emacs.d";

  services.emacs = {
    enable = true;
    package = myEmacs;
  };
}
