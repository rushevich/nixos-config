{ self, inputs, ... }:
let
  c = import ../_lib/palette.nix inputs;
  rgb = name: "rgb(${c.hex.${name}})";
in
{
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
            path = "${../../wallpapers/w3.jpg}";
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
            rounding = 0;
            outline_thickness = 2;
            outer_color = rgb "steel";
            inner_color = rgb "ink-soft";
            font_color = rgb "fg";
            check_color = rgb "sand";
            fail_color = rgb "alert";
            capslock_color = rgb "caret";
            placeholder_text = "<span foreground='${c.fg-dim}'>password</span>";
          }
        ];
      };
    };
  };
}
