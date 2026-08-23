{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # enableLsColors = true;
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];
    # host
    initContent = lib.mkAfter ''
    setopt PROMPT_SUBST
    
    autoload -Uz vcs_info
    precmd() { vcs_info }
    zstyle ':vcs_info:git:*' formats '%b '
             
    PROMPT='%F{}%f%F{#4682b4}%~%f%F{#eee685} ''${vcs_info_msg_0_}%f $ '
    RPROMPT='%F{#131313}%*%f'
    '';
  };
}
