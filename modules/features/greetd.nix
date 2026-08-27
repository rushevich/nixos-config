{ self, inputs, ... }: {
  flake.nixosModules.greetd = { pkgs, lib, ... }: {
    programs.regreet = {
      enable = true;

      font = {
        name = "Iosevka Nerd Font Mono";
        package = pkgs.nerd-fonts.iosevka;
        size = 12;
      };

      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      settings = {
        background = {
          path = "${../../wallpapers/w2.jpg}";
          fit = "Cover";
        };
        GTK.application_prefer_dark_theme = true;
        appearance.greeting_msg = "";
        commands = {
          reboot = [
            "systemctl"
            "reboot"
          ];
          poweroff = [
            "systemctl"
            "poweroff"
          ];
        };
      };

      extraCss = ''
        				@define-color bg      #111111;
        				@define-color surface #1b1e26;
        				@define-color line    #2a2f3a;
        				@define-color fg      #e0eeee;
        				@define-color dim     #838b8b;
        				@define-color accent  #4682b4;
        				@define-color bright  #00b2ee;
        				@define-color sel     #104e8b;

        				* {
        					font-family: "Iosevka Nerd Font Mono", monospace;
        					font-size: 12pt;
        				}

        				window, .background {
        					background-color: @bg;
        					color: @fg;
        				}

        				label { color: @dim; }

        				entry, combobox button, button {
        					background-image: none;
        					background-color: @bg;
        					color: @fg;
        					border: 1px solid @line;
        					border-radius: 0;
        					padding: 6px 10px;
        					box-shadow: none;
        					caret-color: @bright;
        				}

        				entry:focus, combobox button:focus, button:focus {
        					border-color: @accent;
        					box-shadow: none;
        				}

        				button:hover  { color: @bright; border-color: @accent; }
        				button:active { background-color: @sel; color: @fg; }

        				selection { background-color: @sel; color: @fg; }

        				#error_info, .error { color: #cd0000; }
        			'';
    };
  };
}
