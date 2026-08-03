{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.myWaybar = inputs.wrapper-modules.wrappers.waybar.wrap {
      inherit pkgs;
      settings = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        modules-left = [ "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];

        "niri/workspaces" = {
          format = "{value}";
        };

        clock = {
          format = "{:%H:%M  %a %d %b}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
          format-charging = "{capacity}% ";
          states = { warning = 30; critical = 15; };
        };

        network = {
          format-wifi = "{essid} ";
          format-ethernet = "eth ";
          format-disconnected = "off ";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "muted ";
          format-icons = { default = [ "" "" "" ]; };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        tray = { spacing = 10; };
      };

      "style.css".content = ''
        * {
          font-family: monospace;
          font-size: 13px;
        }
        window#waybar {
          background: #1e1e2e;
          color: #cdd6f4;
        }
        #workspaces button {
          padding: 0 8px;
          color: #cdd6f4;
        }
        #workspaces button.active {
          background: #89b4fa;
          color: #1e1e2e;
        }
        #clock, #battery, #network, #pulseaudio, #tray {
          padding: 0 10px;
        }
        #battery.warning { color: #f9e2af; }
        #battery.critical { color: #f38ba8; }
      '';
    };
  };
}
