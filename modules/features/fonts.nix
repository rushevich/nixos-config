{ self, inputs, ... }: {
	flake.nixosModules.fonts = { pkgs, ... }: {
	fonts = {
		packages = with pkgs; [
			nerd-fonts.iosevka
			noto-fonts-color-emoji
			noto-fonts
		];

		fontconfig.defaultFonts = {
			monospace = [ "Iosevka Nerd Font Mono" ];
			# sansSerif = [ "Iosevka" ];
			emoji = [ "Noto Color Emoji" ];
		};
	};
	};
}
