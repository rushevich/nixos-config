{ self, inputs, ... }: {
	flake.nixosConfigurations.platinum = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.platinumConfiguration
		];
	};
}
