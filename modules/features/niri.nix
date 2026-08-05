{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };
  perSystem = { pkgs, lib, ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        prefer-no-csd = _: {};
        environment = {
          XCURSOR_THEME = "Bibata-Modern-Classic";
          XCURSOR_SIZE = "24";
        };
        cursor = {
          xcursor-theme = "Bibata-Modern-Classic";
          xcursor-size = 24;
        };
        
	input = {
		keyboard = {
			xkb.layout = "us,ua";
			xkb.options = "caps:ctrl_modifier";
		};

		touchpad = {
			natural-scroll = _: {};
			scroll-method = "two-finger";
			scroll-factor = 0.5;   # slower than default
				tap = _: {};
			accel-profile = "flat";
		};
	};
        layout.gaps = 5;

	spawn-at-startup = [ 
    # we can leave this as spawn, not very important
		[ (lib.getExe pkgs.swaybg) "-i" "${../../wallpapers/w1.jpg}" "-m" "fill" ]
    # spawning through 
    [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]
    # moved to spawning through HM
#    [ (lib.getExe pkgs.emacs-pgtk) "--daemon" ]
	];

  xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

	hotkey-overlay.skip-at-startup = _: {};

        binds = {
          # Hotkey overlay: niri's own "show all binds" screen
          "Mod+Shift+Slash".show-hotkey-overlay = _: {};

          # Programs
          "Mod+Return".spawn = [ (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myAlacritty) ];
          "Mod+D".spawn = [ (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myFuzzel) ];
          "Super+Alt+L".spawn = [ (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprlock) ];
	        "Mod+B".spawn = [ "zen" ];
          "Mod+E".spawn = [ "emacsclient" "-c" "-a" "\"\"" ];

          # Window management
          "Mod+Q".close-window = _: {};
          "Mod+F".maximize-column = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+C".center-column = _: {};

          # Focus movement (arrows + hjkl)
          "Mod+Left".focus-column-left = _: {};
          "Mod+Right".focus-column-right = _: {};
          "Mod+Up".focus-window-up = _: {};
          "Mod+Down".focus-window-down = _: {};
          "Mod+H".focus-column-left = _: {};
          "Mod+L".focus-column-right = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+J".focus-window-down = _: {};

          # Move windows / columns
          "Mod+Shift+Left".move-column-left = _: {};
          "Mod+Shift+Right".move-column-right = _: {};
          "Mod+Shift+Up".move-window-up = _: {};
          "Mod+Shift+Down".move-window-down = _: {};
          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+L".move-column-right = _: {};
          "Mod+Shift+K".move-window-up = _: {};
          "Mod+Shift+J".move-window-down = _: {};

          # Workspaces (niri stacks them vertically)
          "Mod+Page_Up".focus-workspace-up = _: {};
          "Mod+Page_Down".focus-workspace-down = _: {};
          "Mod+I".focus-workspace-up = _: {};
          "Mod+U".focus-workspace-down = _: {};
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;

          # Column sizing / consuming
          "Mod+R".switch-preset-column-width = _: {};
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Comma".consume-window-into-column = _: {};
          "Mod+Period".expel-window-from-column = _: {};

          # Screenshots
          "Print".screenshot = _: {};
          "Ctrl+Print".screenshot-screen = _: {};
          "Alt+Print".screenshot-window = _: {};

          # Volume
          "XF86AudioRaiseVolume".spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" ];
          "XF86AudioLowerVolume".spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" ];
          "XF86AudioMute".spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];

          # Brightness
          "XF86MonBrightnessUp".spawn = [ "brightnessctl" "set" "5%+" ];
          "XF86MonBrightnessDown".spawn = [ "brightnessctl" "set" "5%-" ];

          # Session
          "Mod+Shift+E".quit = _: {};
          "Mod+Shift+P".power-off-monitors = _: {};

          # General
          "Mod+Shift+Q".spawn = [ "systemctl" "poweroff"];
        };
	
      };
    };
  };
}
