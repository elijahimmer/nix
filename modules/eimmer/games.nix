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
          -H 1080 -W 1920 -S integer -- ${lib.getExe pkgs.steam}
      ''
    )
  ];

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = true;
      extest.enable = true;
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
