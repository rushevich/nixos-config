{ config, pkgs, lib, ... }: {
	home.packages = with pkgs; [
		emacs-pgtk
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
			    }
