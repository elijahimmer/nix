{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}:
with lib; let
  cfg = config.mein.eimmer.headFull.hyprland;
in {
  options.mein.eimmer.headFull.hyprland = {
    enable = mkEnableOption "enable hyprland" // {default = config.mein.eimmer.headFull.enable;};
    withSwaylock = mkEnableOption "enable swaylock" // {default = config.mein.eimmer.headFull.hyprland.enable;};
  };

  config = mkIf cfg.enable {
    mein.eimmer.headFull.services.target = ["hyprland-session.target"];

    programs = {
      dconf.enable = true;
      hyprland.enable = true;
    };

    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];

    security.pam.services = mkIf cfg.withSwaylock {swaylock = {};};

    home-manager.users.eimmer = {
      home.packages = with pkgs; [seatd xdg-utils];

      programs.swaylock = {
        enable = cfg.withSwaylock;
        settings = {
          scaling = mkForce "fit";
          show-failed-attempts = true;
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof swaylock || swaylock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 600;
              on-timeout = "swaylock";
            }
            {
              timeout = 630;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 1800;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = true;
          variables = ["--all"];
        };
        settings = {
          exec-once = optional cfg.withSwaylock (getExe pkgs.swaylock);

          monitor = [
            "eDP-1, 1920x1080,0x0,1"
          ];
          master = {
            mfact = 0.5;
            orientation = "right";
          };
          general = {
            layout = "master";
            no_focus_fallback = true;
            gaps_in = 0;
            gaps_out = 0;
            border_size = 2;
          };
          decoration = {
            drop_shadow = false;
            blur.enabled = false;
          };
          input = {
            touchpad = {
              disable_while_typing = false;
              natural_scroll = true;
            };
            kb_options = "caps:escape";
            follow_mouse = 2;
            scroll_factor = 0.5;
          };

          misc = {
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            enable_swallow = true;
            swallow_regex = "^(Alacritty)$";
            allow_session_lock_restore = true;

            focus_on_activate = true;
            vfr = true;
            vrr = 2;
            disable_autoreload = true;
          };

          windowrule = [
            "float, title:^(Picture-in-Picture)$"
            "pin,   title:^(Picture-in-Picture)$"
            "move onscreen 100% 0, title:^(Picture-in-Picture)$"
            "suppressevent fullscreen, ^(Signal)$"
          ];

          workspace = [
            "w[tv1], gapsout:0, gapsin:0"
            "f[1], gapsout:0, gapsin:0"
          ];

          windowrulev2 = [
            "bordersize 0, floating:0, onworkspace:w[tv1]"
            "rounding 0, floating:0, onworkspace:w[tv1]"
            "bordersize 0, floating:0, onworkspace:f[1]"
            "rounding 0, floating:0, onworkspace:f[1]"
          ];

          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          bind = let
            grim = getExe pkgs.grim;
            slurp = getExe pkgs.slurp;
            notify = getExe pkgs.notify-desktop;
            wl-copy = getExe' pkgs.wl-clipboard "wl-copy";
            wl-paste = getExe' pkgs.wl-clipboard "wl-paste";

            screenshot = pkgs.writeShellScript "screenshot" ''
              ${grim} - \
              | ${wl-copy} -t image/png && ${wl-paste} \
              > ~/Pictures/Screenshot-$(date +%F_%T).png
              ${notify} 'Screenshot taken' -t 5000
            '';
            screenshotRegion = pkgs.writeShellScript "screenshot-region" ''
              ${grim} -g "$(${slurp})" - \
              | ${wl-copy} -t image/png && ${wl-paste} \
              > ~/Pictures/Screenshot-$(date +%F_%T).png
              ${notify} 'Screenshot of the region taken' -t 5000
            '';
          in [
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
            "SUPER CONTROL, G, exec, ${screenshot}"
            "SUPER SHIFT,   G, exec, ${screenshotRegion}"
            "SUPER SHIFT, code:35, fullscreen"
            "SUPER SHIFT, code:34, fullscreenstate, -1 2"
            "SUPER SHIFT, F, togglefloating"
            "SUPER SHIFT, F, pin"
            "SUPER SHIFT, P, pin"

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

            "SUPER CONTROL, p, exec, ${getExe pkgs.hyprpicker}"
          ];

          bindl = [
              "SUPER SHIFT CONTROL, l, exec, swaylock"
          ];
        };
        extraConfig = let
          exit = key: ''
            bind=SUPER, ${key}, exec,   killall zig-prompt
            bind=SUPER, ${key}, submap, reset
            bind=,      ${key}, exec,   killall zig-prompt
            bind=,      ${key}, submap, reset
          '';

          run-zig-prompt = name: binds: 
          let 
            zig-prompt = inputs.zig-prompt.packages.${system}.default;
            args = ''--separator="  " --font-size=12 --border-size=2'';
            options = builtins.map (bind: ''"${bind.key}=${bind.name}"'') binds;

            opt_str = builtins.concatStringsSep " " options;
          in
            "${getExe zig-prompt} ${args} ${opt_str}";

          launcher = key: name: binds: ''
            bind=SUPER, ${key}, exec,   ${run-zig-prompt name binds}
            bind=SUPER, ${key}, submap, ${name}
            submap=${name}
            ${builtins.foldl' (str: bind: str + bind.bind) "" binds}
            ${exit "ESCAPE"}
            submap=reset
          '';

          mkCmdBindRepeating = key: name: cmd: {
            inherit key name cmd;
            bind = ''
              binde=SUPER, ${key}, exec, ${cmd}
              binde=,      ${key}, exec, ${cmd}
            '';
          };

          mkCmdBindExit = key: name: cmd: {
            inherit key name cmd;
            bind = ''
                bind=SUPER, ${key}, exec, ${cmd}
                bind=,      ${key}, exec, ${cmd}
              ''
              + (exit key);
          };

          appLauncher = launcher "T" "launcher" ([
              (mkCmdBindExit "A" "Alacritty" (getExe pkgs.alacritty))
              (mkCmdBindExit "C" "Chromium" (getExe pkgs.ungoogled-chromium))
              (mkCmdBindExit "D" "Discord" (getExe pkgs.vesktop))
              (mkCmdBindExit "M" "B-Top" "${getExe pkgs.alacritty} --command ${getExe pkgs.btop}")
              (mkCmdBindExit "R" "Signal" (getExe pkgs.signal-desktop))
              (mkCmdBindExit "T" "Firefox" "$BROWSER")
              (mkCmdBindExit "W" "Nautilus" (getExe pkgs.nautilus))
              (mkCmdBindExit "Z" "Zotero" (getExe pkgs.zotero))
            ]
            ++ (optionals config.mein.bluetooth.enable [(mkCmdBindExit "Q" "Blueman" "blueman-manager")])
            ++ (optionals config.mein.games.enable [(mkCmdBindExit "S" "Steam" "steam") (mkCmdBindExit "B" "Retroarch" "retroarch")])
            ++ (optionals config.mein.pipewire.enable [(mkCmdBindExit "V" "Volume" (getExe pkgs.pwvucontrol))]));

          powerCenter = launcher "DELETE" "power" [
            (mkCmdBindExit "A" "Poweroff" "systemctl poweroff")
            (mkCmdBindExit "H" "Hibernate" "systemctl hibernate")
            (mkCmdBindExit "L" "Lock" "swaylock") # TODO: Make loginctl lock-session work here.
            (mkCmdBindExit "Q" "Exit" "hyprctl dispatch exit")
            (mkCmdBindExit "S" "Suspend" "systemctl suspend-then-hibernate")
            (mkCmdBindExit "R" "Restart" "systemctl restart")
          ];

          mpc = getExe pkgs.mpc-cli;
          mpc-cmd = cmd: ''${getExe pkgs.notify-desktop} "$(${mpc} ${cmd} | head --lines 2 -)" -u low'';
          musicCenter = launcher "M" "music" [
            (mkCmdBindExit "A" "Play" (mpc-cmd "play"))
            (mkCmdBindExit "H" "Toggle Pause" (mpc-cmd "toggle"))
            (mkCmdBindExit "T" "Next Song" (mpc-cmd "next"))
            (mkCmdBindExit "S" "Status" (mpc-cmd "status"))
            (mkCmdBindExit "R" "Reset Volume" (mpc-cmd "vol 30"))
            (mkCmdBindRepeating "W" "Volume +2%" (mpc-cmd "vol +2"))
            (mkCmdBindRepeating "D" "Volume -2%" (mpc-cmd "vol -2"))
          ];
        in
          appLauncher
          + powerCenter
          + optionalString config.mein.music.enable musicCenter;
      };
    };
  };
}
