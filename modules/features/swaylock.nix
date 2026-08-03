{ self, inputs, ... }: {
  flake.nixosModules.swaylock = { pkgs, ... }: {
    security.pam.services.swaylock = {};
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.mySwaylock
    ];
  };
  perSystem = { pkgs, lib, ... }: {
    packages.mySwaylock = inputs.wrapper-modules.wrappers.swaylock.wrap {
      inherit pkgs;
      settings = {
        color = "1e1e2e";
        indicator-radius = 100;
        ignore-empty-password = true;
      };
    };
  };
}
