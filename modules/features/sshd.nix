{ self, inputs, ... }: {
  flake.nixosModules.sshd =
    { ... }:
    {
      services.openssh = {
        enable = true;
        # don't expose 22 on every interface; only allow it over the tailnet below
        openFirewall = false;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ "george" ];
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

      users.users.george.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0QHOgtHwWSbm/O4plQT68iU8bASYATcW1KQj7iCGuT george@rushevich.com"
      ];
    };
}
