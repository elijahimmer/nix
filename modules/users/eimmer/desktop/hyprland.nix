{
  lib,
  pkgs,
  ...
}: {
  home-manager.users.eimmer = {
    pkgs,
    lib,
    ...
  }: {
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
          blur = {
            enabled = false;
          };
        };
        # animations.enabled = false;
        input = {
          touchpad = {
            disable_while_typing = false;
            natural_scroll = true;
          };
          kb_options = caps:escape;
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          enable_swallow = true;
          swallow_regex = "Alacritty";

          focus_on_activate = true;
          vfr = true;
          vrr = 2;
          disable_autoreload = true;
        };
        bind = let
          grim = lib.getExe pkgs.grim;
          slurp = lib.getExe pkgs.slurp;
          wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
          wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
          notify = "${pkgs.notify-desktop}/bin/notify-desktop";
          screenshotRegion = pkgs.writeShellScript "screenshot-region" ''
            ${grim} -g "$(${slurp})" - \
            | ${wl-copy} -t image/png && ${wl-paste} \
            > ~/Screenshots/Screenshot-$(date +%F_%T).png
            ${notify} 'Screenshot of the region taken' -t 5000
          '';
          screenshot = pkgs.writeShellScript "screenshot" ''
            ${grim} - \
            | ${wl-copy} -t image/png && ${wl-paste} \
            > ~/Screenshots/Screenshot-$(date +%F_%T).png
            ${notify} 'Screenshot of whole screen taken' -t 5000
          '';
        in [
          "SUPER, A, cyclenext"
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
          "SUPER, T, submap, launcher"
          "SUPER, DELETE, submap, power"
        ];
      };
      extraConfig = ''
        submap = launcher
        bind = , escape, submap, reset
        bind = SUPER, A, exec, alacritty
        bind = SUPER, A, submap, reset
        bind = SUPER, S, exec, ${pkgs.gamemode}/bin/gamemoderun gamescope -fe --force-grab-cursor --sharpness 0 -H 1080 -W 2560 -S integer -- steam
        bind = SUPER, S, submap, reset
        bind = SUPER, H, exec, ${pkgs.webcord-vencord}/bin/webcord
        bind = SUPER, H, submap, reset
        bind = SUPER, T, exec, $BROWSER
        bind = SUPER, T, submap, reset
        bind = SUPER, R, exec, ${pkgs.signal-desktop}/bin/signal-desktop
        bind = SUPER, R, submap, reset
        bind = SUPER, B, exec, ${pkgs.bitwarden}/bin/bitwarden
        bind = SUPER, B, submap, reset
        bind = SUPER, W, exec, thunar
        bind = SUPER, W, submap, reset
        submap = power
        bind = , escape, submap, reset
        bind = , Q, exit
        bind = , A, exec, systemctl poweroff
        bind = , S, exec, systemctl suspend-then-hibernate
        bind = , S, submap, reset
        bind = , H, exec, systemctl hibernate
        bind = , H, submap, reset
        bind = , L, exec, lock
        bind = , L, submap, reset
        submap = reset
      '';
    };

    home.packages = with pkgs; [seatd xdg-utils swaylock];
  };

  programs.hyprland.enable = true;

  systemd.user.services.swaybg = {
    wantedBy = ["hyprland-session.target"];
    script = "${lib.getExe pkgs.swaybg} --image ${./background.png} --mode fit --color '#191724'";
  };
}
