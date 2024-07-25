{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mein.env;
in
  with lib; {
    config = mkMerge [
      (mkIf cfg.withCodingPkgs {
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
