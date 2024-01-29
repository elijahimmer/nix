{
  pkgs,
  lib,
  ...
}: {
  systemd.user = {
    services.playlist-updater = {
      serviceConfig = {
        WorkingDirectory = "/home/eimmer/Music";
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
                --yes-playlist";
    };
    timers = {
      playlist-updater = {
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
      musicDirectory = "/home/eimmer/Music/";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Piprwire"
        }
      '';
    };
  };
}
