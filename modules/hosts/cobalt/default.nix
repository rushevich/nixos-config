{ self, inputs, ... }: {
	flake.nixosConfigurations.cobalt = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.cobaltConfiguration
		];
	};
}
