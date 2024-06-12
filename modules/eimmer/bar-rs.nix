{system,...}:
{
  home-manager.users.eimmer = {pkgs, lib, inputs, config,...}: {
    systemd.user.services.bar-rs = {
      Unit = {
        Description = "bar-rs Wayland GTK4 bar";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Environment = "PATH=${config.home.profileDirectory}/bin";
        ExecStart = "${lib.getExe inputs.bar-rs.packages.${system}.default} --updated-last ${builtins.readFile ../../updated_last}";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
