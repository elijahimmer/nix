{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mein.env;
in {
  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && cfg.withPkgs) {
      environment.systemPackages = with pkgs; [
        bat
        btop
        calc
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

        (writeScriptBin "n" "nix-shell -p $@")
        (writeScriptBin "nr" ''
          NIX_SHELL_RUN_COMMAND=$@ nix-shell -p "$1" --command ${pkgs.writeScript "nix-run-in-shell" ''
            $NIX_SHELL_RUN_COMMAND
          ''}
        '')
        (writeScriptBin "ns" ''nix search --offline nixpkgs $@'')
        (writeScriptBin "nse" ''nix search --offline nixpkgs '\.$1$' '')
      ];
    })
    (lib.mkIf (cfg.enable && cfg.withCodingPkgs) {
      environment.systemPackages = with pkgs; [
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
    })
  ];
}
