{ self, inputs, ...}: {
	flake.nixosModules.alacritty = { pkgs, lib, ... }: {
		environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myAlacritty ];
	};

  perSystem = { pkgs, lib, ... }: {
    packages.myAlacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      settings = {
        window = {
          padding = { x = 8; y = 8; };
          opacity = 0.95;
          decorations = "none";
        };

        font = {
          normal = {
            family = "Iosevka Nerd Font Mono";
            style = "Regular";
          };
          size = 12;
        };

        colors = {
          primary = {
            background = "#1e1e2e";
            foreground = "#cdd6f4";
          };
          normal = {
            black   = "#45475a";
            red     = "#f38ba8";
            green   = "#a6e3a1";
            yellow  = "#f9e2af";
            blue    = "#89b4fa";
            magenta = "#f5c2e7";
            cyan    = "#94e2d5";
            white   = "#bac2de";
          };
        };

        scrolling = {
          history = 10000;
        };

        cursor = {
          style = { shape = "Block"; blinking = "On"; };
        };
      };
    };
  };
}
