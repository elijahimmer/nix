_: {
  home-manager.users.eimmer = {inputs, ...}: {
    programs = {
      bash.enable = true;

      zoxide = {
        enable = true;
        enableBashIntegration = true;
        options = ["--cmd cd"];
      };
    };
  };
}
