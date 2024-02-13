{
  lib,
  pkgs,
  mods,
  system,
  ...
}: {
  programs.hyprland.enable = true;
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  # needed to get swaylock to actually unlock
  security.pam.services.swaylock = {};

  systemd.user.services.swaybg = {
    wantedBy = ["hyprland-session.target"];
    script = "${lib.getExe pkgs.swaybg} --image ${toString mods.theme.background} --mode fit --color '#191724'";
  };

  home-manager.users.eimmer = {
    pkgs,
    lib,
    inputs,
    ...
  }:{
    home.packages = with pkgs; [seatd xdg-utils];
    programs.swaylock = {
      enable = true;
      settings = {
        scaling = lib.mkForce "fit";
        show-failed-attempts = true;
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        # TODO: Get bar-rs to be able to interact with pipewire while being a systemd service
        exec = let 
          bar-rs = lib.getExe inputs.bar-rs.packages.${system}.default;
          killall = lib.getExe pkgs.killall;
        in [ "${killall} .bar-rs-wrapped; ${bar-rs}" ];

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
        bind = let
            grim = lib.getExe pkgs.grim;
            slurp = lib.getExe pkgs.slurp;
            wl-copy = "${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
            wl-paste = "${lib.getExe' pkgs.wl-clipboard "wl-paste"}";
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
          "SUPER SHIFT, Q, movetoworkspace, 6"
          "SUPER SHIFT, D, movetoworkspace, 7"
          "SUPER SHIFT, R, movetoworkspace, 8"
          "SUPER SHIFT, W, movetoworkspace, 9"
          "SUPER SHIFT, B, movetoworkspace, 10"
        ];
      };
      extraConfig = let
        run-in-place = command: let
          current-workspace = "hyprctl activeworkspace | rg \\d+ -o | head --lines=1";
        in "hyprctl dispatch -- exec [workspace $(${current-workspace}) silent] ${command}";

        launch-wlr-wk = name: menu: "${lib.getExe pkgs.wlr-which-key} ${
          pkgs.writeText "launch-wlr-wk-${name}.yaml"
          (builtins.toJSON ({
            menu = lib.attrsets.mapAttrs' (name: lib.attrsets.nameValuePair (lib.strings.toLower name)) menu;
            background = "#1f1d2e"; separator = " ➜ "; corner_r     = 10; margin_bottom = 0;
            color      = "#e0def4"; anchor = "center"; padding      = 15; margin_left   = 0; 
            border     = "#ebbcba"; border_width  = 2; margin_right = 0;  margin_top    = 0;
          }))
        }";

        kill-wlr-wk = "killall wlr-which-key";
        mk-key-bind = key: cmd: ''
          bind=SUPER, ${key}, exec, ${cmd}
          bind=SUPER, ${key}, exec, ${kill-wlr-wk}
          bind=SUPER, ${key}, submap, reset
          bind=,      ${key}, exec, ${cmd}
          bind=,      ${key}, exec, ${kill-wlr-wk}
          bind=,      ${key}, submap, reset
        '';
        mk-key-bind-kill = key: cmd: ''
          bind=SUPER, ${key}, exec, ${cmd}
          bind=SUPER, ${key}, exec, ${kill-wlr-wk}
          bind=SUPER, ${key}, submap, reset
          bind=,      ${key}, exec, ${cmd}
          bind=,      ${key}, exec, ${kill-wlr-wk}
          bind=,      ${key}, submap, reset
        '';
        wlr-wk-cfg = binds: lib.lists.foldl (acc: bind: acc // {${bind.key} = {desc = bind.name; cmd = "";};}) {} binds;
        launcher = key: name: binds: ''
          bind=SUPER, ${key}, exec,   ${launch-wlr-wk name (wlr-wk-cfg binds)}
          bind=SUPER, ${key}, submap, ${name}
          submap=${name}
          ${builtins.foldl' (str: {key, cmd, ...}: str + (mk-key-bind-kill key cmd)) "" binds}
          bind=SUPER, ESCAPE, exec,   killall wlr-which-key
          bind=SUPER, ESCAPE, submap, reset
          bind=,      ESCAPE, exec,   killall wlr-which-key
          bind=,      ESCAPE, submap, reset
          submap=reset
        '';

        mkBind = key: name: cmd: {inherit key name cmd;};
        mkAppBind = key: name: cmd: (mkBind key name (run-in-place cmd));
        alacritty = lib.getExe pkgs.alacritty;
        appLauncher = launcher "T" "launcher" [
          (mkAppBind "A" "Alacritty" alacritty)
          (mkAppBind "B" "Bitwarden" (lib.getExe pkgs.bitwarden))
          (mkAppBind "D" "Discord"   (lib.getExe pkgs.vesktop))
          (mkAppBind "M" "B-Top"     "${alacritty} --command ${lib.getExe pkgs.btop}")
          (mkAppBind "R" "Signal"    (lib.getExe pkgs.signal-desktop))
          (mkAppBind "S" "Steam"     (lib.getExe pkgs.steam))
          (mkAppBind "T" "Firefox"   "$BROWSER")
          (mkAppBind "V" "Volume"    (lib.getExe pkgs.pavucontrol))
          (mkAppBind "W" "Nautilus"  (lib.getExe pkgs.gnome.nautilus))
          (mkAppBind "Z" "Zotero"    (lib.getExe pkgs.zotero))
        ];
        powerCenter = launcher "DELETE" "power" [
          (mkBind "A" "Poweroff"  "systemctl poweroff")
          (mkBind "H" "Hibernate" "systemctl hibernate")
          (mkBind "L" "Lock"      (lib.getExe pkgs.swaylock))
          (mkBind "Q" "Exit"      "hyprctl dispatch exit")
          (mkBind "S" "Suspend"   "systemctl suspend-then-hibernate")
        ];
        notify-cmd = cmd: ''${lib.getExe pkgs.notify-desktop} "$(${cmd} | head --lines 2 -)" -u low'';
        mpc = lib.getExe pkgs.mpc-cli;
        musicCenter = launcher "M" "music" [
          (mkBind "A" "Play"         (notify-cmd "${mpc} play"))
          (mkBind "H" "Toggle Pause" (notify-cmd "${mpc} toggle"))
          (mkBind "T" "Next Song"    (notify-cmd "${mpc} next"))
          (mkBind "S" "Status"       (notify-cmd "${mpc} status"))
          (mkBind "W" "Volume +10%"  (notify-cmd "${mpc} vol +10"))
          (mkBind "R" "Reset Volume" (notify-cmd "${mpc} vol 30"))
          (mkBind "D" "Volume -10%"  (notify-cmd "${mpc} vol -10"))
        ];
        resizeCenter = launcher "R" "resize" [];
      in 
        appLauncher
        + powerCenter
        + musicCenter;
    };
  };
}
