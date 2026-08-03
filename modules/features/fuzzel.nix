{ self, inputs, ... }:
{
	flake.nixosModules.fuzzel = { pkgs, lib, ... }:
	{
		environment.systemPackages = [ self.packages.${pkgs.stdevn.hostPlatform.system}.myFuzzel ];	
	};

	perSystem = { pkgs, lib, ... }:
	{
		packages.myFuzzel = inputs.wrapper-modules.wrappers.fuzzel.wrap
		{
			inherit pkgs;
			settings = 
			{
				main = { terminal = "alacritty"; layer = "overlay"; auto-select = true; };
				border = { radius = 0; width = 1; };
			};
		};
	};
}
