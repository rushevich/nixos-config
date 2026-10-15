# Usage:  let c = import ../_lib/palette.nix inputs; in ... c.night, c.hex.night
inputs:
let
  c = builtins.fromJSON (
    builtins.readFile "${inputs.dotfiles}/emacs/.emacs.d/themes/blue-dark-palette.json"
  );
in
c
// {
  hex = builtins.mapAttrs (_: v: builtins.substring 1 6 v) c;

  ansi = {
    normal = {
      black = c.ink-soft;
      red = c.alert;
      green = c.plus-hi;
      yellow = c.sand;
      blue = c.steel;
      magenta = c.slate-hi;
      cyan = c.sea;
      white = c.steel-hi;
    };
    bright = {
      black = c.mute;
      red = c.minus-hi;
      green = c.plus-bright;
      yellow = c.caret;
      blue = c.bright;
      magenta = c.pale;
      cyan = c.cadet;
      white = c.fg-hi;
    };
  };
}
