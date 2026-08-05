 { self, inputs, ... }: {
  flake.nixosModules.hyprlock = { pkgs, ... }: {
    security.pam.services.hyprlock = {};
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprlock
    ];
  };

  perSystem = { pkgs, lib, ... }: {
    packages.myHyprlock = inputs.wrapper-modules.wrappers.hyprlock.wrap {
      inherit pkgs;
      settings = {
        general = {
          grace = 5;
          hide_cursor = true;
          ignore_empty_input = true;
        };

        background = [
          {
            path = "${../../wallpapers/w2.jpg}";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
          }
        ];
      };
    };
  };
}
