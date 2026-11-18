{ self, inputs, ... }: {
  flake.nixosModules.tailscale =
    { ... }:
    {
      services.tailscale = {
        enable = true;
        # opens UDP 41641 so peers can connect directly instead of via DERP relays
        openFirewall = true;
      };
    };
}
