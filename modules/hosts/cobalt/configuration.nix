{ self, inputs, ... }: {
  flake.nixosModules.cobaltConfiguration =
    {
      config,
      libs,
      pkgs,
      ...
    }:

    {
      imports = [
        # Include the results of the hardware scan.
        self.nixosModules.cobaltHardware
        self.nixosModules.alacritty
        self.nixosModules.niri
        self.nixosModules.greetd
        self.nixosModules.fonts
        self.nixosModules.zen
        self.nixosModules.hm
        self.nixosModules.waybar
        self.nixosModules.swayidle
        self.nixosModules.mako
        self.nixosModules.hyprlock
        self.nixosModules.imv
        self.nixosModules.fuzzel

      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "cobalt"; # Define your hostname.

      # Configure network connections interactively with nmcli or nmtui.
      networking.networkmanager.enable = true;

      # Set your time zone.
      # time.timeZone = "America/New_York";
      services.automatic-timezoned.enable = true;

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Select internationalisation properties.
      # i18n.defaultLocale = "en_US.UTF-8";
      # console = {
      #   font = "Lat2-Terminus16";
      #   keyMap = "us";
      #   useXkbConfig = true; # use xkb.options in tty.
      # };

      users.users.george = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
          tree
        ];
      };

      # List packages installed in system profile.
      # You can use https://search.nixos.org/ to find more packages (and options).
      environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        git
        neovim
        brightnessctl
        papirus-icon-theme
        nautilus
        man-pages
        openconnect 
      ];

      # thanks to: https://discourse.nixos.org/t/some-manpage-related-stuff-you-might-want-to-turn-on/38835
      documentation = {
        dev.enable = true;
        man.generateCaches = true;
        nixos.includeAllModules = true;
      };

      security.polkit.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };

      services.gnome.gnome-keyring.enable = true;

      programs.dconf.profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
          };
        }
      ];
      programs.zsh.enable = true;
      users.users.george.shell = pkgs.zsh;

      zramSwap = {
        enable = true;
        memoryPercent = 50;
      };

      services.logind.settings.Login.HandleLidSwitch = "suspend";

      systemd.services.disable-usb-wakeup = {
        description = "Disable XHC0 wakeup (spurious resume fix)";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart =
            "${pkgs.bash}/bin/bash -c '"
            + "grep -q \"^XHC0.*enabled\" /proc/acpi/wakeup && echo XHC0 > /proc/acpi/wakeup; true'";
        };
      };

      hardware.keyboard.qmk.enable = true;

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;

      # This option defines the first version of NixOS you have installed on this particular machine,
      # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
      #
      # Most users should NEVER change this value after the initial install, for any reason,
      # even if you've upgraded your system to a new NixOS release.
      #
      # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
      # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
      # to actually do that.
      #
      # This value being lower than the current NixOS release does NOT mean your system is
      # out of date, out of support, or vulnerable.
      #
      # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
      # and migrated your data accordingly.
      #
      # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "26.05"; # Did you read the comment?
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Enable real-time processing for audio to prevent dropouts
      security.rtkit.enable = true;

      # Ensure legacy PulseAudio is disabled to prevent conflicts
      # hardware.pulseaudio.enable = false;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true; # This module translates audio for Discord
      };

      nixpkgs.config.allowUnfree = true;
    };
}
