{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib; {
  imports = [
    ./starcitizen.nix
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
  options.mein.games.enable = mkEnableOption "enable gaming configurations";

  config = mkIf config.mein.games.enable {
    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
        extest.enable = true;
        gamescopeSession.enable = true;
        platformOptimizations.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };
    services.pipewire.lowLatency.enable = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      (
        writeShellScriptBin "steam-bigpicture" ''
          ${lib.getExe' gamemode "gamemoderun"} ${lib.getExe gamescope} \
            -fe --force-grab-cursor --sharpness 0 \
            -H 1440 -W 3440 -S integer -- ${lib.getExe steam} -tenfoot -pipewire-dmabuf
        ''
      )
      rpcs3
      (retroarch.override {
        cores = with libretro; [
          pcsx2
          parallel-n64
        ];
      })
    ];
  };
}
