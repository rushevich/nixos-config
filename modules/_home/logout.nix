{ config, pkgs, lib, ... }: {
  programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock";     action = "hyprlock";             text = "Lock";     keybind = "l"; }
      { label = "logout";   action = "niri msg action quit"; text = "Logout";   keybind = "e"; }
      { label = "suspend";  action = "sleep 1; systemctl suspend";    text = "Suspend";  keybind = "u"; }
      { label = "reboot";   action = "systemctl reboot";     text = "Reboot";   keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff";   text = "Shutdown"; keybind = "s"; }
    ];
    style = ''
      * {
        font-family: "Iosevka Nerd Font Mono", monospace;
        color: #e0eeee;
        background-image: none;
        transition: 20ms;
      }
      window {
        background: rgba(17, 17, 17, 0.9);
      }
      button {
        color: #e0eeee;
        background-color: #171717;
        border: 2px solid #4682b4;
        border-radius: 12px;
        margin: 8px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 20%;
        box-shadow: none;
        text-shadow: none;
      }
      button:focus, button:hover {
        background-color: #104e8b;
        border-color: #00b2ee;
        color: #e0eeee;
        outline: none;
      }
      #lock     { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
      #logout   { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
      #suspend  { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
      #reboot   { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
      #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
    '';
  };
}
