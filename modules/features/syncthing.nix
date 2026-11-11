{ self, inputs, ... }: {
  flake.nixosModules.syncthing =
    { ... }:
    {
      services.syncthing = {
        enable = true;
        user = "george";
        dataDir = "/home/george";
        openDefaultPorts = true;
        settings = {
          devices = {
            cobalt.id = "COBALT-DEVICE-ID";
            platinum.id = "6UPVKWG-5YKPRUV-Y6TUB72-X6V6GHM-I3BJZ7D-R4DG47Q-EM7LGMP-OYC4IQO";
          };
          folders.learnharness = {
            path = "/home/george/.config/LearnHarness";
            devices = [
              "cobalt"
              "platinum"
            ];
          };
        };
      };
    };
}
