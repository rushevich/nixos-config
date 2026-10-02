{ self, inputs, ... }: {
  flake.nixosModules.unfree = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      webex
    ];
  };
}
