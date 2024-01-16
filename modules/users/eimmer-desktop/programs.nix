{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    element-desktop
    (
      pkgs.writeShellScriptBin "steam-bigpicture" ''
        ${pkgs.gamemode}/bin/gamemoderun gamescope \
          -fe --force-grab-cursor --sharpness 0 \
          -H 1080 -W 1920 -S integer -- steam
      ''
    )
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
  };
}
