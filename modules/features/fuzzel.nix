{ self, inputs, ... }:
{
  flake.nixosModules.fuzzel =
    { pkgs, ... }:
    let
      p = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment.systemPackages = [
        p.myFuzzel
        p.fuzzel-clip
        p.fuzzel-power
        p.fuzzel-audio
        p.fuzzel-windows
        pkgs.papirus-icon-theme
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      fuzzel = lib.getExe self'.packages.myFuzzel;
    in
    {
      packages.myFuzzel = inputs.wrapper-modules.wrappers.fuzzel.wrap {
        inherit pkgs;
        settings = {
          main = {
            terminal = "alacritty";
            layer = "overlay";
            font = "Iosevka Nerd Font Mono-14";
            icon-theme = "Papirus-Dark";
            prompt = ''"❯ "'';
            show-actions = true; # desktop actions, e.g. "New Private Window"
            match-counter = true;
            lines = 12;
            width = 40;
            horizontal-pad = 20;
            vertical-pad = 12;
            inner-pad = 8;
          };
          border = {
            radius = 0;
            width = 1;
          };
          colors = {
            background = "111111ee";
            text = "e0eeeeff";
            prompt = "6ca6cdff";
            placeholder = "838b8bff";
            input = "e0eeeeff";
            match = "00b2eeff";
            selection = "104e8bff";
            selection-text = "e0eeeeff";
            selection-match = "8ee5eeff";
            counter = "7d7d7dff";
            border = "4682b4ff";
          };
        };
      };

      packages.fuzzel-clip = pkgs.writeShellApplication {
        name = "fuzzel-clip";
        runtimeInputs = with pkgs; [
          cliphist
          wl-clipboard
        ];
        text = ''
          cliphist list | ${fuzzel} --dmenu --prompt "clip ❯ " | cliphist decode | wl-copy
        '';
      };

      packages.fuzzel-power = pkgs.writeShellApplication {
        name = "fuzzel-power";
        text = ''
          choice=$(printf '%s\0icon\x1f%s\n' \
            Lock system-lock-screen \
            Suspend system-suspend \
            Logout system-log-out \
            Reboot system-reboot \
            Shutdown system-shutdown \
            | ${fuzzel} --dmenu --lines 5 --prompt "power ❯ ") || exit 0
          case "$choice" in
            Lock)     ${lib.getExe self'.packages.myHyprlock} ;;
            Suspend)  systemctl suspend ;;
            Logout)   niri msg action quit --skip-confirmation ;;
            Reboot)   systemctl reboot ;;
            Shutdown) systemctl poweroff ;;
          esac
        '';
      };

      packages.fuzzel-audio = pkgs.writeShellApplication {
        name = "fuzzel-audio";
        runtimeInputs = with pkgs; [
          pulseaudio
          jq
          libnotify
        ];
        text = ''
          kind=''${1:-sink}
          json=$(pactl -f json list "''${kind}s")
          filter='.[] | select(.name | endswith(".monitor") | not)'
          mapfile -t names < <(jq -r "$filter | .name" <<<"$json")
          mapfile -t descs < <(jq -r "$filter | .description" <<<"$json")
          idx=$(printf '%s\n' "''${descs[@]}" | ${fuzzel} --dmenu --index --prompt "$kind ❯ ") || exit 0
          pactl set-default-"$kind" "''${names[$idx]}"
          notify-send "Default $kind" "''${descs[$idx]}"
        '';
      };

      packages.fuzzel-windows = pkgs.writeShellApplication {
        name = "fuzzel-windows";
        runtimeInputs = with pkgs; [ jq ];
        text = ''
          json=$(niri msg -j windows)
          mapfile -t ids < <(jq -r '.[].id' <<<"$json")
          idx=$(jq -r '.[] | "\(.app_id // "")\t\(.title // "")"' <<<"$json" \
            | while IFS=$'\t' read -r app title; do
                printf '%s  %s\0icon\x1f%s\n' "$app" "$title" "$app"
              done \
            | ${fuzzel} --dmenu --index --prompt "win ❯ ") || exit 0
          niri msg action focus-window --id "''${ids[$idx]}"
        '';
      };
    };
}
