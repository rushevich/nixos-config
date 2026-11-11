{ self, inputs, ... }: {
  flake.nixosModules.syncthing =
    { ... }:
    {
      services.syncthing = {
        enable = true;
        user = "george";
        dataDir = "/home/george";
        openDefaultPorts = true;
        # settings = {
        #   devices = {
        #     cobalt.id = "COBALT-DEVICE-ID";
        #     platinum.id = "PLATINUM-DEVICE-ID";
        #   };
        #   folders.learnharness = {
        #     path = "/home/george/.config/LearnHarness";
        #     devices = [
        #       "cobalt"
        #       "platinum"
        #     ];
        #   };
        # };
      };
    };
}
