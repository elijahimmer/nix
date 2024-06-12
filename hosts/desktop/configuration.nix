{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix
    ./packages.nix

    misc.music
    misc.noisetorch
    games.default
    games.starcitizen
    eimmer.bar-rs
  ];

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;


  security.polkit.enable = true;
  # Let video group access backlight
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.toybox}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.toybox}/bin/chmod g+w $sys$devpath/brightness"
  '';

  # Actually takes code dumps for debugging.
  systemd.coredump.enable = true;

  boot = {
    tmp.useTmpfs = true;
    loader = {
      grub = {
        memtest86.enable = true;
        enableCryptodisk = true;
        timeoutStyle = "hidden";
        efiSupport = true;
        device = "nodev";
        extraConfig = "GRUB_TIMEOUT=0";
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };
}
