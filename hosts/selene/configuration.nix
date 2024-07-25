{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix

    #misc.music
    #misc.bluetooth
  ];

  mein = {
    eimmer.headFull.enable = true;
    env.withCodingPkgs = true;
    pipewire.enable = true;
    pipewire.noisetorch.enable = true;
    services.music.enable = true;
    theme.enable = true;
    games.enable = true;
    games.starCitizen.enable = true;
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    acpi
  ];

  services.btrfs.autoScrub.enable = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  security.polkit.enable = true;
  # Let video group access backlight
  #services.udev.extraRules = ''
  #  ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.toybox}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.toybox}/bin/chmod g+w $sys$devpath/brightness"
  #'';

  # Actually takes code dumps for debugging.
  systemd.coredump.enable = true;

  boot = {
    initrd.secrets = {"/luks" = "/luks";};
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
