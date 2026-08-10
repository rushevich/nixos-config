{ inputs, pkgs, lib, ... }: {
  programs.sioyek = {
  enable = true;
  config = {
    background_color = "1.0 1.0 1.0";
    startup_commands = "toggle_dark_mode";
  };
};
}
