_: {
  home-manager.users.eimmer = {lib, pkgs, ...}: {
    programs.firefox = {
      enable = true;
      profiles = {
        normal = {
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
                iconUpdateURL = lib.mkIf (icon == null) iconURL;
              };
            in {
              "Nix Packages" = engine {
                baseUrl = "https://search.nixos.org";
                search = "/packages?channel=unstable&query={searchTerms}";
                icon = "${icons}/nix-snowflake.svg";
                definedAliases = ["@np" "@nixp" "@nix-packages"];
              };
              "NixOS Options" = engine {
                baseUrl = "https://search.nixos.org";
                search = "/options?channel=unstable&query={searchTerms}";
                icon = "${icons}/nix-snowflake-white.svg";
                definedAliases = ["@no" "@nixo" "@nix-options"];
              };
              "NixOS Wiki" = engine {
                baseUrl = "https://nixos.wiki";
                search = "/index.php?search={searchTerms}";
                iconUpdateURL = "/favicon.png";
                definedAliases = ["@nw" "@nixw" "@nix-wiki"];
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
                definedAliases = ["@rstd" "@stdr" "@stdrs" "@std-rust" "@rust-std"];
              };
              "Crates.io" = engine {
                baseUrl = "https://crates.io";
                search = "/search?q={searchTerms}";
                iconUpdateURL = "/assets/cargo.png";
                definedAliases = ["@cargo" "@crates" "@crs" "@rsc" "@rust-crates"];
              };
              "Docs.rs" = {
                urls = [{template = "https://docs.rs/releases/search?query={searchTerms}";}];
                iconUpdateURL = "https://docs.rs/favicon.ico";
                definedAliases = ["@docs-rust" "@drs" "@rsd" "@rust-docs"];
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
    };
  };
}
