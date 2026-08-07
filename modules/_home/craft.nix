{ pkgs, lib, config, ...} : {
  home.packages = with pkgs; [
    prismlauncher
    jdk21
  ];
}
