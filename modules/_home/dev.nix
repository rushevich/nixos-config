{ pkgs, ... }: {
  home.packages = with pkgs; [
    # C/C++ toolchain
    gcc16
    clang-tools # clangd
    cmake
    ninja
    gnumake
    gdb
    lldb
    pkg-config

    # scripting
    python3

    # language servers
    lua-language-server
    pyright
    slang-server
    verible

    # core dev utilities
    git
    ripgrep
    fd
    jq
    tree
    curl
    wget

    # nix tooling
    nixfmt
    nil # nix language server
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
