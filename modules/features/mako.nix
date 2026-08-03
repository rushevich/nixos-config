{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.myMako = inputs.wrapper-modules.wrappers.mako.wrap {
      inherit pkgs;
      settings = {
        # global settings
        font = "monospace 11";
        background-color = "#1e1e2e";
        text-color = "#cdd6f4";
        border-color = "#89b4fa";
        border-size = 2;
        border-radius = 8;
        default-timeout = 5000;
        icon-location = "left";
        # section: overrides for high-urgency notifications
        "urgency=high" = {
          border-color = "#f38ba8";
          default-timeout = 0;
        };
      };
    };
  };
}
