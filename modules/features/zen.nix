{ self, inputs, ... }: {
  flake.nixosModules.zen =
    { pkgs, lib, ... }:
    let
      extension = shortId: guid: {
        name = guid;
        value = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
          installation_mode = "normal_installed";
        };
      };

      prefs = {
        "extensions.autoDisableScopes" = 0;
        "extensions.pocket.enabled" = false;
      };

      extensions = [
        (extension "ublock-origin" "uBlock0@raymondhill.net")
        (extension "competitive-companion" "{74e326aa-c645-4495-9287-b6febc5565a7}")
        (extension "carrot" "{f0eeb71a-e5d6-48e6-a818-568a6bef1bc0}")
      ];
    in
    {
      environment.systemPackages = [
        (pkgs.wrapFirefox
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
          {
            extraPrefs = lib.concatLines (
              lib.mapAttrsToList (
                name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
              ) prefs
            );
            extraPolicies = {
              DisableTelemetry = true;
              ExtensionSettings = builtins.listToAttrs extensions;
            };
          }
        )
      ];
    };
}
