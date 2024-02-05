{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.sessionVariables = rec {
    BROWSER = lib.getExe config.home-manager.users.eimmer.programs.firefox.finalPackage;
    DEFAULT_BROWSER = BROWSER;
  };

  home-manager.users.eimmer = {lib, ...}: {

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
              oncePerDay = 24 * 60 * 60 * 1000;
              engine = {
                baseUrl,
                search,
                definedAliases ? [],
                icon ? null,
                iconUpdateURLIsAbsolute ? false,
                iconUpdateURL ? null,
                updateInterval ? oncePerDay,
              }: let
                iconURL =
                  if iconUpdateURLIsAbsolute
                  then iconUpdateURL
                  else "${baseUrl}${iconUpdateURL}";
              in {
                inherit icon updateInterval definedAliases;
                urls = [{template = "${baseUrl}${search}";}];
                iconUpdateURL = lib.mkIf (isNull icon) iconURL;
              };
            in {
              "Nix Packages" = engine {
                baseUrl = "https://search.nixos.org";
                search = "/packages?channel=unstable&query={searchTerms}";
                icon = "${icons}/nix-snowflake.svg";
                definedAliases = ["@np" "@nix-packages"];
              };
              "NixOS Options" = engine {
                baseUrl = "https://search.nixos.org";
                search = "/options?channel=unstable&query={searchTerms}";
                icon = "${icons}/nix-snowflake-white.svg";
                definedAliases = ["@no" "@nix-options"];
              };
              "NixOS Wiki" = engine {
                baseUrl = "https://nixos.wiki";
                search = "/index.php?search={searchTerms}";
                iconUpdateURL = "/favicon.png";
                definedAliases = ["@nw" "@nix-wiki"];
              };
              "Home Manager Options" = engine {
                baseUrl = "https://mipmip.github.io/home-manager-option-search";
                search = "/?query={searchTerms}";
                iconUpdateURL = "/images/favicon.png";
                definedAliases = ["@hm" "@home-manager"];
              };
              "Rust STD Docs" = engine {
                baseUrl = "https://doc.rust-lang.org/stable";
                search = "/std/?search={searchTerms}";
                iconUpdateURL = "/static.files/favicon-2c020d218678b618.svg";
                definedAliases = ["@rstd" "@stdr" "@rust-std"];
              };
              "Crates.io" = engine {
                baseUrl = "https://crates.io";
                search = "/search?q={searchTerms}";
                iconUpdateURL = "/assets/cargo.png";
                definedAliases = ["@crs" "@rsc" "@rust-crates"];
              };
              "Docs.rs" = {
                urls = [{template = "https://docs.rs/releases/search?query={searchTerms}";}];
                iconUpdateURL = "https://docs.rs/favicon.ico";
                definedAliases = ["@drs" "@rsd" "@rust-docs"];
              };
              "Wolfram Alpha" = engine {
                baseUrl = "https://www.wolframalpha.com";
                search = "/input?i={searchTerms}";
                iconUpdateURL = "/_next/static/images/favicon_1zbE9hjk.ico";
                definedAliases = ["@wolf" "@wolframalpha"];
              };
              "D&D Beyond" = engine {
                baseUrl = "https://www.dndbeyond.com";
                search = "/search?q={searchTerms}";
                iconUpdateURL = "https://media.dndbeyond.com/images/web/favicon.png";
                iconUpdateURLIsAbsolute = true;
                definedAliases = ["@dnd" "@dnd-beyond"];
              };
              "Dictonary.com" = engine {
                baseUrl = "https://www.dictionary.com";
                search = "/browse/{searchTerms}";
                iconUpdateURL = "/94e56a525da4e9fe0cda.png";
                definedAliases = ["@dict" "@dictonary"];
              };
              "Thesaurus.com" = engine {
                baseUrl = "https://www.thesaurus.com";
                search = "/browse/{searchTerms}";
                iconUpdateURL = "/0d297be7e698b98c9da8.png";
                definedAliases = ["@thes" "@thesaurus"];
              };
              "GitHub" = engine {
                baseUrl = "https://github.com";
                search = "/search?q={searchTerms}&type=repositories";
                iconUpdateURL = "/favicon.ico";
                definedAliases = ["@gh" "@github"];
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
              "Rust STD Docs"
              "Crates.io"
              "Docs.rs"
              "Wolfram Alpha"
              "D&D Beyond"
              "Dictonary.com"
              "Thesaurus.com"
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
            "${addons_url}/decentraleyes/latest.xpi"
            "${addons_url}/ublock-origin/latest.xpi"
            "${addons_url}/privacy-badger17/latest.xpi"
            "${addons_url}/canvasblocker/latest.xpi"
            "${addons_url}/darkreader/lastest.xpi"
            "${addons_url}/bitwarden-password-manager/lastest.xpi"
            "${addons_url}/firefox-color/lastest.xpi"
            "${addons_url}/pay-by-privacy/latest.xpi"
            "${addons_url}/private-relay/latest.xpi"
            "https://www.zotero.org/download/connector/dl?browser=firefox"
          ];
        };
      };
    };
  };
}
