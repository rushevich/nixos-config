{ self, inputs, ... }: {
  flake.nixosModules.hm = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;      # HM uses the system's nixpkgs, not its own
      useUserPackages = true;    # user packages go into the system profile
      users.george = import ../_home/george.nix;  # your actual home config
    };
  };
}
