{
  pkgs,
  lib,
  ...
}: let musicDirectory = "/home/eimmer/Music"; in {
  environment.systemPackages = with pkgs; [mpc-cli];
  systemd.user = {
    services.playlist-updater = {
      after = ["network-online.target"];
      serviceConfig.WorkingDirectory = musicDirectory;
      script = "${lib.getExe pkgs.yt-dlp} -x \\
                PLCQ2DK3yQCr7uR2F3QUfeq4T9svTFI4hl \\
                --exec after_move:'chmod 550' \\
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
    timers.playlist-updater = {
      wantedBy = ["default.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
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
