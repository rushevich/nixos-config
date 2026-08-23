{ self, inputs, ... }: {
	flake.nixosModules.desktop = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.desktopConfiguration
		];
	};
}
