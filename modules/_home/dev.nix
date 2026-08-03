{ pkgs , ... }: {
	home.packages = with pkgs; [
# C/C++ toolchain
		gcc16
			clang
			clang-tools        # clangd
			cmake
			ninja
			gnumake
			gdb
			lldb
			pkg-config

# scripting
			python3

# language servers (for editor LSP everywhere)
			lua-language-server
			pyright

# core dev utilities
			git
			ripgrep
			fd
			jq
			tree
			curl
			wget

# nix tooling
			nixfmt-rfc-style
			nil                # nix language server
			];
		       }
