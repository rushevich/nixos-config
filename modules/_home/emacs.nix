{
  config,
  pkgs,
  lib,
  ...
}:
let
  myEmacs = pkgs.emacs31-pgtk.pkgs.withPackages (epkgs: [ epkgs.notmuch ]);
  myCookies =
    pkgs.writers.writePython3Bin "my_cookies"
      {
        libraries = [ pkgs.python3Packages.browser-cookie3 ];
      }
      ''
        import glob
        import os
        import browser_cookie3

        files = glob.glob(os.path.expanduser("~/.config/zen/*/cookies.sqlite"))
        jar = browser_cookie3.firefox(
            cookie_file=max(files, key=os.path.getmtime),
            domain_name="leetcode.com",
        )
        for c in jar:
            print(c.name, c.value)
      '';
in
{
  home.packages = with pkgs; [
    myEmacs
    myCookies
    ripgrep
    fd
    git
  ];

  home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    		if [ ! -d "${config.home.homeDirectory}/dotfiles" ]; then
    			${pkgs.git}/bin/git clone https://github.com/rushevich/general-dotfiles "${config.home.homeDirectory}/dotfiles"
    				fi
    				'';
  xdg.configFile."emacs".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/emacs/.emacs.d";

  services.emacs = {
    enable = true;
    package = myEmacs;
  };
}
