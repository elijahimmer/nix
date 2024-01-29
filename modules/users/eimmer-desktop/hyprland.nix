{
  lib,
  pkgs,
  ...
}: {
  programs.hyprland.enable = true;

  systemd.user.services.swaybg = {
    wantedBy = ["hyprland-session.target"];
    script = "${lib.getExe pkgs.swaybg} --image ${./background.png} --mode fit --color '#191724'";
  };

  home-manager.users.eimmer = {
    pkgs,
    lib,
    ...
  }: let
    run-in-place = command: let
      current-workspace = "hyprctl activeworkspace | rg \\d+ -o | head --lines=1";
    in "hyprctl dispatch -- exec [workspace $(${current-workspace}) silent] ${command}";

    grim = lib.getExe pkgs.grim;
    slurp = lib.getExe pkgs.slurp;
    wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
    wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
    notify = lib.getExe pkgs.notify-desktop;

    screenshotRegion = pkgs.writeShellScript "screenshot-region" ''
      ${grim} -g "$(${slurp})" - \
      | ${wl-copy} -t image/png && ${wl-paste} \
      > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
      ${notify} 'Screenshot of the region taken' -t 5000
    '';
    screenshot = pkgs.writeShellScript "screenshot" ''
      ${grim} - \
      | ${wl-copy} -t image/png && ${wl-paste} \
      > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
      ${notify} 'Screenshot of whole screen taken' -t 5000
    '';

    mk-key-bind = desc: cmd: {
      inherit desc;
      cmd = run-in-place cmd;
    };
    mk-key-bind-close = desc: cmd: {
      inherit desc;
      cmd = "${run-in-place cmd}; killall wlr-which-key; hyprctl dispatch submap reset";
    };
    launch-wlr-wk = name: cfg: "${lib.getExe pkgs.wlr-which-key} ${
      pkgs.writeText "launch-wlr-wk-${name}.yaml"
      (builtins.toJSON ({
          background = "#1f1d2e";
          color = "#e0def4";
          border = "#ebbcba";
          separator = " ➜ ";
          border_width = 2;
          corner_r = 10;
          padding = 15;
          anchor = "center";
          margin_right = 0;
          margin_bottom = 0;
          margin_left = 0;
          margin_top = 0;
        }
        // cfg))
    }";
  in {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        monitor = [
          "eDP-1, 1920x1080,0x0,1"
        ];
        master = {
          mfact = 0.5;
          no_gaps_when_only = 1;
          orientation = "right";
        };
        general = {
          layout = "master";
          no_focus_fallback = true;
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
          no_cursor_warps = 0;
          resize_on_border = true;
        };

        decoration = {
          drop_shadow = false;
          blur.enabled = false;
        };
        #animations.enabled = false;
        input = {
          touchpad = {
            disable_while_typing = false;
            natural_scroll = true;
          };
          kb_options = "caps:escape";
          follow_mouse = 2;
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          #enable_swallow = true;
          swallow_regex = "Alacritty";

          focus_on_activate = true;
          vfr = true;
          vrr = 2;
          disable_autoreload = true;
        };
        bind = [
          "SUPER, H, movefocus, l"
          "SUPER, J, movefocus, u"
          "SUPER, K, movefocus, d"
          "SUPER, L, movefocus, r"
          "SUPER, A, cyclenext"
          "SUPER SHIFT, H, movewindow, l"
          "SUPER SHIFT, J, movewindow, u"
          "SUPER SHIFT, K, movewindow, d"
          "SUPER SHIFT, L, movewindow, r"
          "SUPER SHIFT, A, swapnext"
          "SUPER, X, killactive"
          "SUPER SHIFT, G, exec, ${screenshotRegion}"
          "SUPER CTRL, G, exec, ${screenshot}"
          "SUPER SHIFT, code:35, fullscreen"
          "SUPER SHIFT, code:34, fakefullscreen"

          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"
          "SUPER, 0, workspace, 10"

          # Alternate Keyboard buttons
          "SUPER, Q, workspace, 6"
          "SUPER, D, workspace, 7"
          "SUPER, R, workspace, 8"
          "SUPER, W, workspace, 9"
          "SUPER, B, workspace, 10"

          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"
          "SUPER SHIFT, 6, movetoworkspace, 6"
          "SUPER SHIFT, 7, movetoworkspace, 7"
          "SUPER SHIFT, 8, movetoworkspace, 8"
          "SUPER SHIFT, 9, movetoworkspace, 9"
          "SUPER SHIFT, 0, movetoworkspace, 10"

          # These few are for when I have my alternate keyboard
          "SUPER SHIFT, Q, movetoworkspace, 6"
          "SUPER SHIFT, D, movetoworkspace, 7"
          "SUPER SHIFT, R, movetoworkspace, 8"
          "SUPER SHIFT, W, movetoworkspace, 9"
          "SUPER SHIFT, B, movetoworkspace, 10"

          "SUPER, DELETE, exec, ${launch-wlr-wk "power" {
            menu = {
              q = mk-key-bind "Exit" "hyprctl dispatch exit";
              a = mk-key-bind "Poweroff" "systemctl poweroff";
              s = mk-key-bind "Suspend" "systemctl suspend-then-hibernate";
              h = mk-key-bind "Hibernate" "systemctl hibernate";
              l = mk-key-bind "Lock" "lock";
            };
          }}"
        ];
      };
      extraConfig = let
        end-key = key: ''
          bind=SUPER, ${key}, exec, killall wlr-which-key
          bind=SUPER, ${key}, submap, reset
          bind=, ${key}, exec, killall wlr-which-key
          bind=, ${key}, submap, reset
        '';
        keybind = key: cmd: ''
          bind=SUPER, ${key}, exec, ${run-in-place cmd}
          bind=,${key},exec, ${run-in-place cmd}
          ${end-key key}
        '';
        opt = desc: {
          inherit desc;
          cmd = "";
        };
      in ''
        bind=SUPER, T, exec, ${launch-wlr-wk "launcher" {
          menu = {
            w = opt "Nautilus";
            b = opt "Bitwarden";
            r = opt "Signal";
            t = opt "Firefox";
            a = opt "Alacritty";
            s = opt "Steam";
            d = opt "discord";
          };
        }}
        bind=SUPER, T, submap, launcher
        submap=launcher
        ${keybind "W" "${pkgs.gnome.nautilus}/bin/nautilus"}
        ${keybind "B" (lib.getExe pkgs.bitwarden)}
        ${keybind "R" (lib.getExe pkgs.signal-desktop)}
        ${keybind "T" "$BROWSER"}
        ${keybind "A" "alacritty"}
        ${keybind "S" (lib.getExe pkgs.steam)}
        ${keybind "D" (lib.getExe pkgs.webcord-vencord)}
        ${end-key "ESCAPE"}
        submap=reset
      '';
    };
    home.packages = with pkgs; [seatd xdg-utils swaylock];
  };
}
