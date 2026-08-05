{ self, inputs, ... }: {
  flake.nixosModules.mako = { pkgs, lib, ... }: {
    systemd.user.services.mako = {
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myMako;
        Restart = "on-failure";
      };
    };
  };
  perSystem = { pkgs, lib, ... }: {
    packages.myMako = inputs.wrapper-modules.wrappers.mako.wrap {
      inherit pkgs;
      settings = {
        # global settings
        font = "Iosevka Nerd Font Mono-10";
        background-color = "#1e1e2e";
        text-color = "#cdd6f4";
        border-color = "#89b4fa";
        border-size = 2;
        border-radius = 8;
        default-timeout = 5000;
        icon-location = "left";
        # overrides for high-urgency notifications
        "urgency=high" = {
          border-color = "#f38ba8";
          default-timeout = 0;
        };
      };
    };
  };
}
