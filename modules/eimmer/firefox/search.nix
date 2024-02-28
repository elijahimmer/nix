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
              icons = pkgs.nixos-icons + "/share/icons/hicolor/scalable/apps";
              engine = {
                search,
                definedAliases ? [],
                icon ? null,
              }: {
                inherit icon definedAliases;
                urls = [{template = search;}];
              };
            in {
              "Nix Packages" = engine {
                search = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                icon = icons + "/nix-snowflake.svg";
                definedAliases = ["@np" "@nixp" "@nix-packages"];
              };
              "NixOS Options" = engine {
                search = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                icon = icons + "/nix-snowflake-white.svg";
                definedAliases = ["@no" "@nixo" "@nix-options"];
              };
              "NixOS Wiki" = engine {
                search = "https://nixos.wiki/index.php?search={searchTerms}";
                icon = ./icons/nixos.wiki.webp;
                definedAliases = ["@nw" "@nixw" "@nix-wiki"];
              };
              "Noogle" = engine {
                search = "https://noogle.dev/q?term={searchTerms}&limit=50&page=1";
                icon = ./icons/noogle.dev.png;
                definedAliases = ["@noogle"];
              };
              "Home Manager Options" = let 
                base_url = "https://mipmip.github.io/home-manager-option-search"; 
              in engine {
                search = "${base_url}/?query={searchTerms}";
                icon = ./icons/home_manager.png;
                definedAliases = ["@hm" "@home-manager"];
              };
              "Rust STD Docs" = engine {
                search = "https://doc.rust-lang.org/stable/std/?search={searchTerms}";
                icon = ./icons/rust_std_docs.svg;
                definedAliases = ["@rstd" "@stdr" "@stdrs" "@std-rust" "@rust-std"];
              };
              "Crates.io" = engine {
                search = "https://crates.io/search?q={searchTerms}";
                icon = ./icons/crates.io.png;
                definedAliases = ["@cargo" "@crates" "@crs" "@rsc" "@rust-crates"];
              };
              "Docs.rs" = {
                baseUrl = "https://docs.rs/releases/search?query={searchTerms}";
                icon = ./icons/docs.rs.ico;
                definedAliases = ["@docs-rust" "@drs" "@rsd" "@rust-docs"];
              };
              "Wolfram Alpha" = engine {
                search = "https://www.wolframalpha.com/input?i={searchTerms}";
                icon = ./icons/wolfamalpha.com.ico;
                definedAliases = ["@wolf" "@wolframalpha"];
              };
              "D&D Beyond" = engine {
                search = "https://www.dndbeyond.com/search?q={searchTerms}";
                icon = ./icons/dndbeyond.com.png;
                definedAliases = ["@dnd" "@dnd-beyond"];
              };
              "Oxford English Dictionary" = engine {
                search = "https://www.oed.com/search/dictionary/?scope=Entries&q={searchTerms}";
                icon = ./icons/oed.com.ico;
                definedAliases = ["@dict" "@dictonary" "@oxford"];
              };
              "GitHub" = engine {
                search = "https://github.com/search?q={searchTerms}&type=repositories";
                icon = ./icons/github.com.ico;
                definedAliases = ["@gh" "@github"];
              };
              "Epic Music World" = engine {
                search = "https://www.youtube.com/@EpicMusicWorld_Official/search?query={searchTerms}";
                icon = ./icons/epic_music_world.jpg;
                definedAliases = ["@epic" "@music"];
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
              "Noogle"
              "Home Manager Options"
              "GitHub"
              "Rust STD Docs"
              "Crates.io"
              "Docs.rs"
              "Wolfram Alpha"
              "D&D Beyond"
              "Epic Music World"
              "Oxford English Dictionary"
              "Wikipedia (en)"
              "Google"
            ];
          };
        };
      };
    };
  };
}
