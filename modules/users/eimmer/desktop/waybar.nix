{
  pkgs,
  lib,
  ...
}: {
  home-manager.users.eimmer = {...}: {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 30;
          output = [
            "eDP-1"
          ];
          modules-left = ["hyprland/workspaces" "hyprland/submap"];
          modules-center = [];
          modules-right = ["bluetooth" "wifi" "battery"];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };

          "bluetooth" = {
            format-on = "󰂯";
            format-off = "󰂲";
            format-disabled = "󰂲";
            format-connected = "󰂱";
          };

          "battery" = {
            full-at = "99";
            format = "{icon}";
            states = {
              max = 100;
              high = 70;
              mid = 50;
              warning = 30;
              critical = 15;
            };
            format-icons = ["󰂃" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            format-charging = "󱧥";
            format-full = "󱟢";
          };
        };
      };
    };
  };

  systemd = {
    user = let
      p = "waybar";
      c = lib.getExe pkgs.waybar;
    in {
      services.${p} = {
        wantedBy = ["hyprland-session.target"];
        script = c;
        #reload = c;
        #preStop = "kill ${p}";
      };
    };
  };
}
