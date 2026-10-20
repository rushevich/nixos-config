{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.sioyek = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "sioyek";
      paths = [ pkgs.sioyek ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/sioyek --set QT_QPA_PLATFORM xcb";
    };
    config = {
      background_color = "1.0 1.0 1.0";
      startup_commands = "toggle_dark_mode";
    };
  };
}
