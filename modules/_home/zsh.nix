{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  c = import ../_lib/palette.nix inputs;
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
    ];
    initContent = lib.mkAfter ''
      setopt PROMPT_SUBST
      autoload -Uz vcs_info add-zsh-hook
      add-zsh-hook precmd vcs_info
      zstyle ':vcs_info:git:*' formats ' on %F{${c.pale-deep}}%b%f'

      PROMPT='%F{${c.fg-dim}}%n%f %F{${c.steel}}%~%f''${vcs_info_msg_0_} %B%(?.%F{${c.plus-hi}}.%F{${c.alert}})❯%f%b '
      RPROMPT='%F{${c.mute-low}}%*%f'
    '';
  };
}
