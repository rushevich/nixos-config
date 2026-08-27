{ self, inputs, ... }: {
  flake.nixosModules.nvidia =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        modesetting.enable = true;

        # Saves and restores VRAM across suspend
        powerManagement.enable = true;

        # Turing (RTX 20xx) and newer only
        open = true;

        nvidiaSettings = true;
      };

      boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };

      hardware.graphics.extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
}
