{
  pkgs,
  lib,
  config,
  ...
}: let
  alacritty = lib.getExe pkgs.alacritty;
in {
  options.mein.eimmer.headFull.alacritty.enable = lib.mkEnableOption "enable alacritty" // {default = config.mein.eimmer.headFull.enable;};

  config = lib.mkIf config.mein.eimmer.headFull.alacritty.enable {
    environment.sessionVariables.TERMINAL = alacritty;
    environment.systemPackages = [
      pkgs.alacritty
      (
        pkgs.writeShellScriptBin "xdg-terminal-exec" ''
          if [ -z "$@" ]
            then
            ${alacritty}
            else
            ${alacritty} -e "$@"
          fi
        ''
      )
      (
        pkgs.writeShellScriptBin "alacritty-solid" ''
          ${alacritty} msg config 'window.opacity = 1'
        ''
      )
      (
        pkgs.writeShellScriptBin "alacritty-clear" ''
          ${alacritty} msg config -r
        ''
      )
    ];

    home-manager.users.eimmer = {stylix, ...}:
      lib.mkMerge [
        (lib.mkIf config.mein.theme.enable {stylix.targets.alacritty.enable = false;})
        {
          programs.alacritty = {
            enable = true;
            settings = {
              keyboard.bindings = [
                {
                  key = "Return";
                  mods = "Control|Shift";
                  action = "SpawnNewInstance";
                }
              ];

              window.opacity = 0.90;

              colors = rec {
                # credit to https://github.com/rose-pine/alacritty, they designed the theme

                primary = {
                  foreground = "#e0def4";
                  background = "#191724";
                  dim_foreground = "#908caa";
                  bright_foreground = "#e0def4";
                };

                cursor = {
                  text = "#e0def4";
                  cursor = "#524f67";
                };

                vi_mode_cursor = {
                  text = "#e0def4";
                  cursor = "#524f67";
                };

                search.matches = {
                  foreground = "#908caa";
                  background = "#26233a";
                };

                search.focused_match = {
                  foreground = "#191724";
                  background = "#ebbcba";
                };

                hints.start = {
                  foreground = "#908caa";
                  background = "#1f1d2e";
                };

                hints.end = {
                  foreground = "#6e6a86";
                  background = "#1f1d2e";
                };

                line_indicator = {
                  foreground = "None";
                  background = "None";
                };
                footer_bar = {
                  foreground = "#e0def4";
                  background = "#1f1d2e";
                };
                selection = {
                  text = "#e0def4";
                  background = "#403d52";
                };

                normal = {
                  black = "#26233a";
                  red = "#eb6f92";
                  green = "#31748f";
                  yellow = "#f6c177";
                  blue = "#9ccfd8";
                  magenta = "#c4a7e7";
                  cyan = "#ebbcba";
                  white = "#e0def4";
                };

                bright = normal // {black = "#6e6a86";};
                dim = bright;
              };

              font = let
                font = "FiraCode Nerd Font";
              in {
                normal = {
                  family = font;
                  style = "Regular";
                };
                bold = {
                  family = font;
                  style = "Bold";
                };
                italic = {
                  family = font;
                  style = "Italic";
                };

                bold_italic = {
                  family = font;
                  style = "Bold Italic";
                };
              };
            };
          };
        }
      ];
  };
}
