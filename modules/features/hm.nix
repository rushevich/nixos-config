{ self, inputs, ... }: {
  flake.nixosModules.hm = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      users.george = import ../_home/george.nix;
    };
  };
}
