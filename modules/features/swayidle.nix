{ self, inputs, ... }: {
	perSystem = { pkgs, lib, ... }: {
		packages.mySwayidle = inputs.wrapper-modules.wrappers.swayidle.wrap {
			inherit pkgs;
			timeouts = [
			{
				timeout = 300;   # 5 min idle: lock
					command = lib.getExe pkgs.hyprlock;
			}
			{
				timeout = 600;   # 10 min idle: screen off, back on when active
					command = "niri msg action power-off-monitors";
				resumeCommand = "niri msg action power-on-monitors";
			}
			];
			events = {
				before-sleep = lib.getExe pkgs.hyprlock;
			};
		};
	};
		       }
