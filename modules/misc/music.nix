{
  pkgs,
  lib,
  ...
}: let musicDirectory = "/home/eimmer/Music"; in {
  environment.systemPackages = with pkgs; [mpc-cli];
  systemd.user = {
    services.playlist-updater = {
      serviceConfig = {
        WorkingDirectory = musicDirectory;
      };
      script = "${lib.getExe pkgs.yt-dlp} -x \\
                PLCQ2DK3yQCr7uR2F3QUfeq4T9svTFI4hl \\
                --exec after_move:'chmod 555' \\
                --download-archive .archive \\
                --prefer-free-formats \\
                --audio-multistreams \\
                --restrict-filenames \\
                --audio-format best \\
                --audio-quality 0 \\
                --embed-thumbnail \\
                --embed-metadata \\
                --yes-playlist
                ${lib.getExe pkgs.mpc-cli} update Music";
    };
    timers = {
      playlist-updater = {
        wants = ["playlist-updater.service"];
        timerConfig = {
          Persistent = true;
          OnUnitActiveSec = "1d";
          Unit = "playlist-updater.service";
        };
      };
    };
  };
  home-manager.users.eimmer = {pkgs, ...}: {
    services.mpd = {
      enable = true;
      inherit musicDirectory;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Pipewire"
        }
     '';
    };
  };
}
