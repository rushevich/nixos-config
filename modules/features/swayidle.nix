{ self, inputs, ... }: {
  flake.nixosModules.swayidle = { pkgs, lib, ... }: {
    systemd.user.services.swayidle = {
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.mySwayidle;
        Restart = "on-failure";
      };
    };
  };
	perSystem = { pkgs, lib, self', ... }: {
		packages.mySwayidle = inputs.wrapper-modules.wrappers.swayidle.wrap {
			inherit pkgs;
			timeouts = [
			{
				timeout = 300;   # 5 min idle: lock
					command = lib.getExe self'.packages.myHyprlock;
			}
			{
				timeout = 600;   # 10 min idle: screen off, back on when active
					command = "niri msg action power-off-monitors";
				resumeCommand = "niri msg action power-on-monitors";
			}
			];
			events = {
				before-sleep = lib.getExe self'.packages.myHyprlock;
			};
		};
	};
}
