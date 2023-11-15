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
          modules-right = ["pulseaudio" "bluetooth" "network" "battery"];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };

          clock = {
            format = "{:%H:%M}  ";
            format-alt = "{:%A, %B %d, %Y (%R)}  ";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              on-click-right = "mode";
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
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
  #  systemd = {
  #    user = {
  #      services.waybar = {
  #        wantedBy = ["hyprland-session.target"];
  #        script = lib.getExe pkgs.waybar;
  #        reloadIfChanged = true;
  #      };
  #    };
  #  };
}