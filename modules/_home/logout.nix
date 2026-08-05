{ config, pkgs, lib, ... }: {
  programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock";     action = "hyprlock";              text = "Lock";     keybind = "l"; }
      { label = "logout";   action = "niri msg action quit";  text = "Logout";   keybind = "e"; }
      { label = "suspend";  action = "systemctl suspend";     text = "Suspend";  keybind = "u"; }
      { label = "reboot";   action = "systemctl reboot";      text = "Reboot";   keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff";    text = "Shutdown"; keybind = "s"; }
    ];
    style = ''
      * {
        font-family: "Iosevka Nerd Font Mono", monospace;
        color: #e0eeee;
      }
      window {
        background: rgba(17, 17, 17, 0.9);
      }
      button {
        color: #e0eeee;
        background: #171717;
        border: 2px solid #4682b4;
        border-radius: 12px;
        margin: 10px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }
      button:focus, button:hover {
        background-color: #104e8b;
        border-color: #00b2ee;
        color: #e0eeee;
        outline: none;
      }
    '';
  };
}
