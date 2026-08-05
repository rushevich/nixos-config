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
          blur = true;
        };

        font = {
          normal = {
            family = "Iosevka Nerd Font Mono";
            style = "Regular";
          };
          size = 12;
        };

        mouse = {
          hide_when_typing = true;
        };

        colors = {
          primary = {
            background = "#111111";   # black (default bg)
            foreground = "#e0eeee";   # azure-light (default fg)
          };

          cursor = {
            text   = "#111111";       # black
            cursor = "#7f7f7f";       # grey-50
          };

          selection = {
            text       = "#111111";   # black (region fg)
            background = "#778899";   # slate-grey (region bg)
          };

          normal = {
            black   = "#171717";      # dark-grey
            red     = "#cd0000";      # red
            green   = "#668b8b";      # pale-turq (stands in for green)
            yellow  = "#eee685";      # khaki
            blue    = "#4682b4";      # blue-steel
            magenta = "#9fb6cd";      # slate-blue
            cyan    = "#008b8b";      # cyan-dark
            white   = "#b0c4de";      # steel-light
          };

          bright = {
            black   = "#7d7d7d";      # grey-49
            red     = "#cd0000";      # red (no brighter variant in palette)
            green   = "#8ee5ee";      # blue-cadet
            yellow  = "#eee685";      # khaki
            blue    = "#00b2ee";      # blue-bright
            magenta = "#add8e6";      # blue-light
            cyan    = "#8ee5ee";      # blue-cadet
            white   = "#efefef";      # off-white
          };
        };
        
        scrolling = {
          history = 10000;
        };

        cursor = {
          style = { shape = "Block"; blinking = "Off"; };
        };
      };
    };
  };
}
