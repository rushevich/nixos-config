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
        # platinum: paste the output of `cat ~/.ssh/id_ed25519.pub` here
        "ssh-ed25519 AAAA... george@platinum"
      ];
    };
}
