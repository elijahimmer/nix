{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    (
      pkgs.writeShellScriptBin "steam-bigpicture" ''
        ${lib.getExe' pkgs.gamemode "gamemoderun"} ${lib.getExe pkgs.gamescope} \
          -fe --force-grab-cursor --sharpness 0 \
          -H 1440 -W 3440 -S integer -- ${lib.getExe pkgs.steam} -tenfoot -pipewire-dmabuf
      ''
    )
  ];

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
