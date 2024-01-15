{pkgs, ...}: {
  environment.sessionVariables = rec {
    BROWSER = "firefox";
    DEFAULT_BROWSER = BROWSER;
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = with pkgs; [tridactyl-native];
  };

  home-manager.users.eimmer = {...}: {
    programs.firefox = {
      enable = true;
      profiles = {
        normal = {
          isDefault = true;
          extraConfig = builtins.readFile ./user.perf;
          search = {
            default = "DuckDuckGo";
            engines = {
              "Nix Packages" = {
                urls = [{template = "https://search.nixos.org/packages?query={searchTerms}";}];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np" "@nixp"];
              };
              "NixOS Options" = {
                urls = [{template = "https://search.nixos.org/options?query={searchTerms}";}];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                definedAliases = ["@no" "@nixo"];
              };
              "NixOS Wiki" = {
                urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@nw" "@nixw"];
              };
              "Home Manager Options" = {
                urls = [{template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";}];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@nw" "@nixw"];
              };
              "Bing".metaData.hidden = true;
              "eBay".metaData.hidden = true;
              "Amazon".metaData.hidden = true;
              "Google".metaData.alias = "@g";
              "Wikipedia".metaData.alias = "@w";
            };
          };
        };
      };
      policies = {
        DisableMasterPasswordCreation = true;
      };
    };
  };
}
