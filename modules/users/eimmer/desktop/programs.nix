{
  pkgs,
  home-manager,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    nativeMessagingHosts.packages = with pkgs; [tridactyl-native];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
  };

  environment.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = EDITOR;
    BROWSER = "librewolf";
    DEFAULT_BROWSER = BROWSER;
    TERMINAL = "alacritty";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  home-manager.users.eimmer = {...}: {
    xdg = {
      desktopEntries = {
        librewolf = {
          name = "LibreWolf";
          genericName = "Web Browser";
          exec = "librewolf %U";
          type = "Application";
          terminal = false;
          categories = ["Application" "Network" "WebBrowser"];
          mimeType = [
            "text/html"
            "text/xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/about"
            "x-scheme-handler/unknown"
          ];
        };
        neovim = {
          name = "Neovim Text Editor";
          genericName = "Text Editor";
          exec = "nvim %U";
          type = "Application";
          terminal = true;
          icon = "terminal";
          categories = ["Utility" "TextEditor"];
          mimeType = ["text/plain"];
        };
      };
    };
  };
}
