{ self, inputs, ... }:
let
  c = import ../_lib/palette.nix inputs;
in
{
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
        font = "Iosevka Nerd Font Mono-10";
        background-color = c.ink-soft;   # same surface as corfu / eldoc-box
        text-color = c.fg;
        border-color = c.slate;          # corfu-border
        progress-color = "over ${c.sel}";
        border-size = 1;
        border-radius = 0;               # square, like fuzzel
        padding = "8";
        default-timeout = 5000;
        icon-location = "left";
        "urgency=low" = { text-color = c.fg-dim; border-color = c.wash-dim; };
        "urgency=high" = { border-color = c.alert; default-timeout = 0; };
      };
    };
  };
}
