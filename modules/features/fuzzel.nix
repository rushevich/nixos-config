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
				main = {
          terminal = "alacritty";
          layer = "overlay";
          auto-select = false;
          font = "Iosevka Nerd Font Mono-14";
          hide-before-typing = true;
        };
				border = { radius = 0; width = 1; };
        colors = {
          background = "111111ee";       # black
          text = "e0eeeeff";             # azure-light
          prompt = "6ca6cdff";           # blue-sky
          placeholder = "838b8bff";      # azure-grey
          input = "e0eeeeff";            # azure-light
          match = "00b2eeff";            # blue-bright (matched substring accent)
          selection = "104e8bff";        # blue-dodger (selected entry bg)
          selection-text = "e0eeeeff";   # azure-light
          selection-match = "8ee5eeff";  # blue-cadet (match within selection)
          counter = "7d7d7dff";          # grey-49
          border = "4682b4ff";           # blue-steel
        };
			};
		};
	};
}
