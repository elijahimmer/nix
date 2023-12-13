{
  lib,
  pkgs,
  ...
}: {
  programs.waybar.enable = true;
  home-manager.users.eimmer = {...}: {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 30;
          output = ["eDP-1"];
          modules-left = ["hyprland/workspaces" "hyprland/submap"];
          modules-center = ["clock"];
          modules-right = ["backlight" "pulseaudio" "bluetooth" "network" "battery"];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "Α";
              "2" = "Β";
              "3" = "Γ";
              "4" = "Δ";
              "5" = "Ε";
              "6" = "Ζ";
              "7" = "Η";
              "8" = "Θ";
              "9" = "Ι";
            };
          };

          clock = {
            format = "{:%H:%M}";
            tooltip-format = "{:%A, %B %d, %Y}";
            on-click-right = "${lib.getExe pkgs.thunderbird} -calender";
          };

          backlight = {
            device = "intel_backlight";
            format = "{icon}\n{percent}";
            format-icons = ["󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
            on-scroll-up = "${lib.getExe pkgs.brightnessctl} s +1%";
            on-scroll-down = "${lib.getExe pkgs.brightnessctl} s 1%-";
          };

          pulseaudio = {
            format = "{icon}\n{volume}";
            format-bluetooth = "{volume} {icon}";
            format-muted = "󰸈";
            format-icons = {
              headphone = "";
              headset = "";
              default = ["" "󰕾"];
            };
            scroll-step = 1;
            on-click = lib.getExe pkgs.pavucontrol;
            ignored-sinks = ["Dummy Output"];

            reverse-scrolling = true;
          };

          network = {
            format = "{icon}";
            format-disconnected = "";
            format-ethernet = "󰈁";
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            tooltip-format = "{ifname} at {signalStrength}";
          };

          bluetooth = {
            format-on = "󰂯";
            format-off = "";
            format-disabled = "󰂲";
            format-connected = "󰂱";
          };

          battery = {
            full-at = "95";
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

  # TODO: Fix this service so that it actually restarts properly on rebuild.
  #       Currently it
  systemd = {
    user = {
      services.waybar = {
        wantedBy = ["hyprland-session.target"];
        script = lib.getExe pkgs.waybar;
        reloadIfChanged = true;
      };
    };
  };
}
