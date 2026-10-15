{ self, inputs, ... }:
let
  c = import ../_lib/palette.nix inputs;
in
{
  flake.nixosModules.alacritty = { pkgs, lib, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myAlacritty ];
  };

  perSystem = { pkgs, lib, ... }: {
    packages.myAlacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      settings = {
        window = {
          padding = {
            x = 8;
            y = 8;
          };
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

        mouse.hide_when_typing = true;
        scrolling.history = 10000;

        cursor = {
          style = {
            shape = "Block";
            blinking = "Off";
          };
          vi_mode_style = {
            shape = "Underline";
            blinking = "Off";
          };
        };

        colors = {
          primary = {
            background = c.night; # default bg
            foreground = c.fg; # default fg
            dim_foreground = c.fg-dim; # shadow
            bright_foreground = c.fg-hi;
          };

          cursor = {
            text = c.night;
            cursor = c.caret;
          }; # cursor face
          vi_mode_cursor = {
            text = c.night;
            cursor = c.cadet;
          };

          selection = {
            text = "CellForeground";
            background = c.sel;
          };

          search = {
            matches = {
              foreground = c.fg-hi;
              background = c.dodger;
            }; # lazy-highlight
            focused_match = {
              foreground = c.night;
              background = c.bright;
            }; # isearch
          };

          hints = {
            start = {
              foreground = c.night;
              background = c.sand;
            };
            end = {
              foreground = c.night;
              background = c.cadet;
            };
          };

          footer_bar = {
            foreground = c.fg-dim;
            background = c.ink-soft;
          }; # header-line
          line_indicator = {
            foreground = c.cadet;
            background = c.ink-soft;
          };

          normal = c.ansi.normal;
          bright = c.ansi.bright;
        };
      };
    };
  };
}
