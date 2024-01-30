{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix
    ./packages.nix

    users.eimmer

    common.all
    env.common
    env.coding

    misc.tailscale
    misc.mullvad
    misc.networkmanager
    misc.pipewire
    misc.bluetooth
  ];

  services = {
    openssh = {
      enable = true;
      startWhenNeeded = true;
      # TODO: Add age nix or another secrets method and get the authorized keys here!
      banner = ''
        ===========================================
          HERE BE DRAGONS; BEWARE OF WATERS AHEAD
        ===========================================
      '';
    };
    btrfs.autoScrub.enable = true;
    tailscale.useRoutingFeatures = "both";
  };

  security.polkit.enable = true;
  # Let video group access backlight
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.toybox}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.toybox}/bin/chmod g+w $sys$devpath/brightness"
  '';

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
