{
  home-manager.users.eimmer = {
    services.mako = {
      enable = true;
      font = "Fira Code";
      #backgroundColor = "#26233a";
      #borderColor = "#1f1d2e";
      margin = "0";
      defaultTimeout = 10000; # 10 seconds
    };
  };
}
