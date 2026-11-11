{ self, inputs, ... }: {
  flake.nixosModules.learnharness =
    { pkgs, ... }:
    let
      pname = "learnharness";
      version = "0.5.0";
      src = pkgs.fetchurl {
        url = "https://github.com/amosblomqvist/learnharness/releases/download/v${version}/LearnHarness-${version}-x86_64.AppImage";
        hash = "sha256-tb2EmK1TyiqOtwgHNK8OxaquwbtqxV8kboUCnMumncM=";
      };
      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      environment.systemPackages = [
        (pkgs.appimageTools.wrapType2 {
          inherit pname version src;
          extraInstallCommands = ''
            install -Dm444 ${contents}/*.desktop -t $out/share/applications
            substituteInPlace $out/share/applications/*.desktop \
              --replace-quiet 'Exec=AppRun' 'Exec=${pname}'
            cp -r ${contents}/usr/share/icons $out/share/ 2>/dev/null || true
          '';
        })
      ];
    };
}
