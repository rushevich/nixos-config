{ pkgs, ... }: {
  home.packages = with pkgs; [
    # C/C++ toolchain
    (lib.hiPrio gcc16)
    (clang.override { gccForLibs = gcc16.cc; })
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
    zip
    unzip

    # nix tooling
    nixfmt
    nil # nix language server

    # compprog
    online-judge-tools
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
