{ self, inputs, ... }: {
  flake.nixosModules.waybar = { pkgs, lib, ... }: {
    systemd.user.services.waybar = {
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myWaybar;
        Restart = "on-failure";
      };
    };
  };
  perSystem = { pkgs, lib, ... }: {
    packages.myWaybar = inputs.wrapper-modules.wrappers.waybar.wrap {
      inherit pkgs;
      settings = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 0;
        margin-top = 6;
        margin-left = 8;
        margin-right = 8;
        margin-bottom = 6;

        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "pulseaudio" "network" "battery" "tray" ];

        "niri/workspaces" = {
          format = "{index}";
        };
        "niri/window" = {
          format = "{title}";
          max-length = 50;
          separate-outputs = true;
        };
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%a %d %b  %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
        cpu = {
          format = "CPU {icon} {usage:02}%";
          format-icons = [
            "<span size='10pt' color='#4a4f5a'>░░░░░░░░░░</span>"
            "<span size='10pt' color='#7fa0c4'>█░░░░░░░░░</span>"
            "<span size='10pt' color='#7fa0c4'>██░░░░░░░░</span>"
            "<span size='10pt' color='#7fa0c4'>███░░░░░░░</span>"
            "<span size='10pt' color='#7fa0c4'>████░░░░░░</span>"
            "<span size='10pt' color='#7fa0c4'>█████░░░░░</span>"
            "<span size='10pt' color='#7fa0c4'>██████░░░░</span>"
            "<span size='10pt' color='#7fa0c4'>███████░░░</span>"
            "<span size='10pt' color='#7fa0c4'>████████░░</span>"
            "<span size='10pt' color='#7fa0c4'>█████████░</span>"
            "<span size='10pt' color='#7fa0c4'>██████████</span>"
          ];
          interval = 2;
        };

        memory = {
          format = "MEM {icon} {percentage:02}%";
          format-icons = [
            "<span size='10pt' color='#4a4f5a'>░░░░░░░░░░</span>"
            "<span size='10pt' color='#8fa8c8'>█░░░░░░░░░</span>"
            "<span size='10pt' color='#8fa8c8'>██░░░░░░░░</span>"
            "<span size='10pt' color='#8fa8c8'>███░░░░░░░</span>"
            "<span size='10pt' color='#8fa8c8'>████░░░░░░</span>"
            "<span size='10pt' color='#8fa8c8'>█████░░░░░</span>"
            "<span size='10pt' color='#8fa8c8'>██████░░░░</span>"
            "<span size='10pt' color='#8fa8c8'>███████░░░</span>"
            "<span size='10pt' color='#8fa8c8'>████████░░</span>"
            "<span size='10pt' color='#8fa8c8'>█████████░</span>"
            "<span size='10pt' color='#8fa8c8'>██████████</span>"
          ];
          interval = 5;
        };

        battery = {
          format = "BAT {icon} {capacity}%";
          format-icons = {
            default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
          };
          states = { warning = 20; critical = 10; };
        };
        network = {
          format = "NET";
          format-wifi = "NET {icon} {signalStrength}%";
          format-ethernet = "NET  eth";
          format-disconnected = "NET ✕";
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          tooltip-format = "{ifname}: {ipaddr}";
        };
        pulseaudio = {
          format = "VOL {icon} {volume}%";
          format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
          format-muted = "VOL 󰝟";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 5;
        };
        tray = { spacing = 8; };
      };

      "style.css".content = ''
        * {
          font-family: "Iosevka Nerd Font Mono", monospace;
          font-size: 13px;
          min-height: 0;
        }
        window#waybar {
          background: transparent;
          color: #c8ccd4;
        }

        /* module islands */
        .modules-left,
        .modules-center,
        .modules-right {
          background: #1b1e26;
          border: 1px solid #2a2f3a;
          border-radius: 10px;
          padding: 0 6px;
          margin: 0 4px;
        }

        #workspaces button {
          padding: 0 9px;
          margin: 3px 2px;
          color: #6b7280;
          background: transparent;
          border-radius: 7px;
        }
        #workspaces button:hover {
          background: #262b36;
          color: #c8ccd4;
        }
        #workspaces button.active {
          background: #3b5b7f;
          color: #dfe6f0;
        }
        #workspaces button.urgent {
          background: #7f4a5a;
          color: #f0dfe4;
        }

        #window {
          color: #8b93a3;
          padding: 0 10px;
        }

        #clock {
          color: #9cb4d4;
          font-weight: bold;
          padding: 0 14px;
        }

        #cpu,
        #memory,
        #pulseaudio,
        #network,
        #battery,
        #tray {
          padding: 0 10px;
          color: #aeb6c4;
        }

        #cpu { color: #7fa0c4; }
        #memory { color: #8fa8c8; }
        #pulseaudio { color: #9cb4d4; }
        #network { color: #7f9fc0; }

        #battery { color: #a0c0a0; }
        #battery.warning { color: #d4c47f; }
        #battery.critical { color: #d48f9f; }
        #battery.charging { color: #8fc4a8; }

        #pulseaudio.muted { color: #5b616e; }
      '';
    };
  };
}
