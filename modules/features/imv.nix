{ self, inputs, ... }: {
  flake.nixosModules.imv = { pkgs, lib, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myImv
    ];
  };
  perSystem = { pkgs, lib, self', ... }: {
    packages.myImv = inputs.wrapper-modules.wrappers.imv.wrap {
      inherit pkgs;
      settings = {
        options = {
          background = "#111111";
          overlay = true;
          overlay_font = "Iosevka Nerd Font Mono:14";
          overlay_text_color = "#e0eeee";
          overlay_background_color = "#171717";
          scaling_mode = "shrink";
          upscaling_method = "nearest";
        };
        binds = {
          "q" = "quit";
          "<Left>" = "prev";
          "<Right>" = "next";
          "h" = "prev";
          "l" = "next";
          "j" = "next";
          "k" = "prev";
          "gg" = "goto 1";
          "<Shift+G>" = "goto -1";
          "x" = "close";
          "f" = "fullscreen";
          "d" = "overlay";
          "+" = "zoom 1";
          "-" = "zoom -1";
          "=" = "zoom actual";
          "c" = "center";
          "r" = "reset";
          "<period>" = "next_frame";
          "<space>" = "toggle_playing";
        };
      };
    };
  };
}
