{ self, inputs, ... }: {
	flake.nixosModules.fonts = { pkgs, ... }: {
	fonts = {
		packages = with pkgs; [
			iosevka-bin
			noto-fonts-color-emoji
			noto-fonts
		];

		fontconfig.defaultFonts = {
			monospace = [ "Iosevka" ];
			# sansSerif = [ "Iosevka" ];
			emoji = [ "Noto Color Emoji" ];
		};
	};
	};
}
