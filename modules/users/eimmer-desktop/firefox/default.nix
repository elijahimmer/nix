{pkgs, ...}: {
  environment.sessionVariables = rec {
    BROWSER = "firefox";
    DEFAULT_BROWSER = BROWSER;
  };

  home-manager.users.eimmer = {...}: {
    programs.firefox = {
      enable = true;
      profiles = {
        normal = {
          isDefault = true;
          extraConfig = builtins.readFile ./user.perf;
          userChrome = builtins.readFile ./userChrome.css;
          userContent = builtins.readFile ./userContent.css;
          search = {
            default = "DuckDuckGo";
            force = true;
            engines = let
              icons = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps";
              nixSearch = "https://search.nixos.org";
            in {
              "Nix Packages" = {
                urls = [{template = "${nixSearch}/packages?channel=unstable&query={searchTerms}";}];
                icon = "${icons}/nix-snowflake.svg";
                definedAliases = ["@np" "@nix-packages"];
              };
              "NixOS Options" = {
                urls = [{template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";}];
                icon = "${icons}/nix-snowflake-white.svg";
                definedAliases = ["@no" "@nix-options"];
              };
              "NixOS Wiki" = {
                urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@nw" "@nix-wiki"];
              };
              "Home Manager Options" = let
                base_url = "https://mipmip.github.io/home-manager-option-search";
              in {
                urls = [{template = "${base_url}/?query={searchTerms}";}];
                iconUpdateURL = "${base_url}/images/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@hm" "@home-manager"];
              };
              "Crates.io" = {
                urls = [{template = "https://crates.io/search?q={searchTerms}";}];
                iconUpdateURL = "https://crates.io/assets/cargo.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@crs" "@rsc" "@rust-crates"];
              };
              "Docs.rs" = {
                urls = [{template = "https://docs.rs/releases/search?query={searchTerms}";}];
                iconUpdateURL = "https://docs.rs/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@drs" "@rsd" "@rust-docs"];
              };
              "D&D Beyond" = {
                urls = [{template = "https://www.dndbeyond.com/search?q={searchTerms}";}];
                iconUpdateURL = "https://media.dndbeyond.com/images/web/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@dnd"];
              };
              "GitHub" = {
                urls = [{template = "https://github.com/search?q={searchTerms}&type=repositories";}];
                iconUpdateURL = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@gh"];
              };
              "Google".metaData.alias = "@g";
              "Wikipedia (en)".metaData.alias = "@w";
              "Bing".metaData.hidden = true;
              "eBay".metaData.hidden = true;
              "Amazon.com".metaData.hidden = true;
            };
            order = [
              "DuckDuckGo"
              "Nix Packages"
              "NixOS Options"
              "NixOS Wiki"
              "Home Manager Options"
              "GitHub"
              "Crates.io"
              "Docs.rs"
              "D&D Beyond"
              "Wikipedia (en)"
              "Google"
            ];
          };
        };
      };
      policies = {
        CaptivePortal = true;
        DisableMasterPasswordCreation = true;
        DisableFirefoxAccounts = false;
        DisplayMenuBar = false;
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisableTelemetry = true;
        DisablePocket = true;
        DNSOverHTTPS.Enabled = false;
        NetworkPrediction = false;
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        SearchSuggestEnabled = false;
        Extensions = let
          addons_url = "https://addons.mozilla.org/firefox/downloads/latest";
        in {
          Install = [
            "${addons_url}/clearurls/latest.xpi"
            "${addons_url}/decentraleyes/latest.xpi"
            "${addons_url}/ublock-origin/latest.xpi"
            "${addons_url}/privacy-badger17/latest.xpi"
            "${addons_url}/canvasblocker/latest.xpi"
            "${addons_url}/darkreader/lastest.xpi"
            "${addons_url}/bitwarden-password-manager/lastest.xpi"
            "${addons_url}/firefox-color/lastest.xpi"
          ];
        };
      };
    };
  };
}
