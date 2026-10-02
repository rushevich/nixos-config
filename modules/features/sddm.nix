{ self, inputs, ... }: {
  flake.nixosModules.sddm =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      # Monitor that gets the login form; every other screen shows only the blurred wallpaper.
      # Check connector names with `niri msg outputs`.
      mainOutput = if config.networking.hostName == "cobalt" then "DP-3" else "eDP-1";

      theme =
        (pkgs.sddm-astronaut.override {
          embeddedTheme = "astronaut";
          # Same palette as the old regreet CSS
          themeConfig = {
            Background = "${../../wallpapers/w3.jpg}";
            CropBackground = "true";
            DimBackground = "0.3";
            DimBackgroundColor = "#111111";

            Font = "Iosevka Nerd Font Mono";
            FontSize = "12";
            RoundCorners = "0";
            HeaderText = "";

            FormBackgroundColor = "#111111";
            BackgroundColor = "#111111";
            LoginFieldBackgroundColor = "#1b1e26";
            PasswordFieldBackgroundColor = "#1b1e26";
            LoginFieldTextColor = "#e0eeee";
            PasswordFieldTextColor = "#e0eeee";
            PlaceholderTextColor = "#838b8b";
            HeaderTextColor = "#e0eeee";
            DateTextColor = "#e0eeee";
            TimeTextColor = "#e0eeee";
            UserIconColor = "#838b8b";
            PasswordIconColor = "#838b8b";
            LoginButtonTextColor = "#e0eeee";
            LoginButtonBackgroundColor = "#104e8b";
            SystemButtonsIconsColor = "#838b8b";
            SessionButtonTextColor = "#838b8b";
            VirtualKeyboardButtonTextColor = "#838b8b";
            DropdownTextColor = "#e0eeee";
            DropdownBackgroundColor = "#1b1e26";
            DropdownSelectedBackgroundColor = "#104e8b";
            HighlightTextColor = "#e0eeee";
            HighlightBackgroundColor = "#104e8b";
            HighlightBorderColor = "#4682b4";
            WarningColor = "#cd0000";
            HoverUserIconColor = "#00b2ee";
            HoverPasswordIconColor = "#00b2ee";
            HoverSystemButtonsIconsColor = "#00b2ee";
            HoverSessionButtonTextColor = "#00b2ee";
            HoverVirtualKeyboardButtonTextColor = "#00b2ee";

            PartialBlur = "true";
            FormPosition = "center";
            HideVirtualKeyboard = "true";
            ForceLastUser = "true";
            PasswordFocus = "true";
          };
        }).overrideAttrs
          (old: {
            # Show the login form only on mainOutput; fully blur the wallpaper on other screens
            postInstall = (old.postInstall or "") + ''
              main=$out/share/sddm/themes/sddm-astronaut-theme/Main.qml
              chmod u+w "$main"
              substituteInPlace "$main" \
                --replace-fail 'id: root' 'id: root
                  readonly property bool isMain: Screen.name == "${mainOutput}"' \
                --replace-fail 'LoginForm {' 'LoginForm {
                  visible: isMain' \
                --replace-fail 'config.FullBlur == "true"' '(config.FullBlur == "true" || !isMain)'
            '';
          });
    in
    {
      services.displayManager = {
        defaultSession = "niri";
        sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
          wayland = {
            enable = true;
            # KWin places one greeter window per monitor; Weston's kiosk mode stacks them
            compositor = "kwin";
          };
          theme = "sddm-astronaut-theme";
          extraPackages = [ theme ];
          settings.Theme = {
            CursorTheme = "Bibata-Modern-Classic";
            CursorSize = 24;
          };
        };
      };

      environment.systemPackages = [
        theme
        pkgs.bibata-cursors
      ];
    };
}
