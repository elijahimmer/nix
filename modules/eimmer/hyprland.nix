{
  lib,
  pkgs,
  mods,
  system,
  ...
}: {
  programs.dconf.enable = true;
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

    services.swayidle = {
      enable = true;
      timeouts = [
        { timeout = 3000;
          command = "swaylock"; }
        { timeout = 6000;
          command = "'hyprctl \"dispatch dpms off\"'"; }
      ];
    };

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
        in [ "${killall} .bar-rs-wrapped bar-rs; ${bar-rs}" ];

        exec-once = [ "swaylock" ];

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
        };

        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          # enable_swallow = true;
          swallow_regex = "Alacritty";

          focus_on_activate = true;
          vfr = true;
          vrr = 2;
          disable_autoreload = true;
        };
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];
        bind = let
            grim = lib.getExe pkgs.grim;
            slurp = lib.getExe pkgs.slurp;
            notify = lib.getExe pkgs.notify-desktop;
            wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
            wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";

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
          "SUPER SHIFT, code:34, fakefullscreen"
          "SUPER SHIFT, F, togglefloating"
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
        ];
      };
      extraConfig = let
        exit = key: ''
          bind=SUPER, ${key}, exec,   killall wlr-which-key
          bind=SUPER, ${key}, submap, reset
          bind=,      ${key}, exec,   killall wlr-which-key
          bind=,      ${key}, submap, reset
        '';

        launch-wlr-wk = name: menu: "${lib.getExe pkgs.wlr-which-key} ${
          pkgs.writeText "launch-wlr-wk-${name}.yaml"
          (builtins.toJSON {
            menu = lib.attrsets.mapAttrs' (name: lib.attrsets.nameValuePair (lib.strings.toLower name)) menu;
            background = "#1f1d2e"; separator = " ➜ "; corner_r     = 10; margin_bottom = 0;
            color      = "#e0def4"; anchor = "center"; padding      = 15; margin_left   = 0; 
            border     = "#ebbcba"; border_width  = 2; margin_right = 0;  margin_top    = 0;
          })
        }";

        wlr-wk-cfg = binds: lib.lists.foldl (acc: bind: acc // {${bind.key} = {desc = bind.name; cmd = "";};}) {} binds;

        launcher = key: name: binds: ''
          bind=SUPER, ${key}, exec,   ${launch-wlr-wk name (wlr-wk-cfg binds)}
          bind=SUPER, ${key}, submap, ${name}
          submap=${name}
          ${builtins.foldl' (str: bind: str + bind.bind) "" binds}
          ${exit "ESCAPE"}
          submap=reset
        '';

        mkCmdBind = key: name: cmd: {
          inherit key name cmd;
          bind = ''
            bind=SUPER, ${key}, exec, ${cmd}
            bind=,      ${key}, exec, ${cmd}
          '';
        };

        mkCmdBindExit = key: name: cmd: { 
          inherit key name cmd;
          bind = ''
            bind=SUPER, ${key}, exec, ${cmd}
            bind=,      ${key}, exec, ${cmd}
          '' + (exit key);
        };

        mkAppBind = key: name: cmd: (mkCmdBindExit key name cmd);
        alacritty = lib.getExe pkgs.alacritty;
        appLauncher = launcher "T" "launcher" [
          (mkAppBind "A" "Alacritty" alacritty)
          (mkAppBind "B" "Bitwarden" (lib.getExe pkgs.bitwarden))
          (mkAppBind "D" "Discord"   (lib.getExe pkgs.vesktop))
          (mkAppBind "M" "B-Top"     "${alacritty} --command ${lib.getExe pkgs.btop}")
          (mkAppBind "R" "Signal"    (lib.getExe pkgs.signal-desktop))
          (mkAppBind "S" "Steam"     "steam-bigpicture")
          (mkAppBind "T" "Firefox"   "$BROWSER")
          (mkAppBind "V" "Volume"    (lib.getExe pkgs.pavucontrol))
          (mkAppBind "W" "Nautilus"  (lib.getExe pkgs.gnome.nautilus))
          (mkAppBind "Z" "Zotero"    (lib.getExe pkgs.zotero))
        ];

        powerCenter = launcher "DELETE" "power" [
          (mkCmdBindExit "A" "Poweroff"  "systemctl poweroff")
          (mkCmdBindExit "H" "Hibernate" "systemctl hibernate")
          (mkCmdBindExit "L" "Lock"      (lib.getExe pkgs.swaylock))
          (mkCmdBindExit "Q" "Exit"      "hyprctl dispatch exit")
          (mkCmdBindExit "S" "Suspend"   "systemctl suspend-then-hibernate")
        ];

        notify-cmd = cmd: ''${lib.getExe pkgs.notify-desktop} "$(${cmd} | head --lines 2 -)" -u low'';
        mpc = lib.getExe pkgs.mpc-cli;
        mpc-cmd = cmd: notify-cmd "${mpc} ${cmd}";
        musicCenter = launcher "M" "music" [
          (mkCmdBindExit "A" "Play"         (mpc-cmd "play"))
          (mkCmdBindExit "H" "Toggle Pause" (mpc-cmd "toggle"))
          (mkCmdBindExit "T" "Next Song"    (mpc-cmd "next"))
          (mkCmdBindExit "S" "Status"       (mpc-cmd "status"))
          (mkCmdBindExit "R" "Reset Volume" (mpc-cmd "vol 30"))
          (mkCmdBind     "W" "Volume +2%"   (mpc-cmd "vol +2"))
          (mkCmdBind     "D" "Volume -2%"   (mpc-cmd "vol -2"))
        ];
      in 
        appLauncher
        + powerCenter
        + musicCenter;
    };
  };
}
