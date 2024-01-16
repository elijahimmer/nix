{...}: {
  home-manager.users.eimmer = {...}: {
    xdg = {
      enable = true;
      mimeApps.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
      desktopEntries = {
        /*        
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
        };*/
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
