{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mein.env;
in
  with lib;
  with pkgs; {
    config.environment.systemPackages =
      optionals (cfg.enable && cfg.withPkgs) [
        alejandra
        bat
        btop
        conceal
        eza
        fd
        gh
        git
        just
        killall
        #nvimpager
        p7zip
        page
        pciutils
        ripgrep
        skim
        wget

        nh

        man-pages
        man-pages-posix

        whois

        renameutils

        (writeScriptBin "n" "nix-shell -p $@")
        (writeScriptBin "nr" ''NIX_SHELL_RUN_COMMAND=$@ nix-shell -p "$1" --command ${pkgs.writeScript "nix_shell_run" "$NIX_SHELL_RUN_COMMAND"}'')
      ]
      ++ optionals (cfg.enable && cfg.withCodingPkgs) [
        typst
        typstfmt

        gcc
        cargo
        rustfmt
        zig
        zig-shell-completions

        elixir
        ghc
      ];
  }
