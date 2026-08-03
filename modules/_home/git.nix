{ ... }: {
  programs.git = {
    enable = true;
    settings.user.name = "rushevich";
    settings.user.email = "george@rushevich.com";
  };
}
