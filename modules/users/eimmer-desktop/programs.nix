{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    element-desktop
    (
      pkgs.writeShellScriptBin "steam-bigpicture" ''
        ${pkgs.gamemode}/bin/gamemoderun gamescope \
          -fe --force-grab-cursor --sharpness 0 \
          -H 1080 -W 1920 -S integer -- steam
      ''
    )
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = with pkgs; [tridactyl-native];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
  };

  environment.sessionVariables = rec {
    BROWSER = "librewolf";
    DEFAULT_BROWSER = BROWSER;
    TERMINAL = "alacritty";
  };

  home-manager.users.eimmer = {...}: {
    xdg = {
      desktopEntries = {
        librewolf = {
          name = "LibreWolf";
          genericName = "Web Browser";
          exec = "librewolf %U";
          type = "Application";
          icon = "LibreWolf";
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
