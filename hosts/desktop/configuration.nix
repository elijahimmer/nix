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
    mods.eimmer.games
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  # for star citizen
  networking.extraHosts = "127.0.0.1 modules-cdn.eac-prod.on.epicgames.com";

  programs.steam.platformOptimizations.enable = true;
  services.pipewire.lowLatency.enable = true; 
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  #programs.gamemode.enable = true;

  nix.settings = {
    substituters = ["https://nix-citizen.cachix.org" "https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  environment.systemPackages = with pkgs; [
    lutris
    mono
    inputs.nix-citizen.packages.${system}.star-citizen
  ];

  nix-citizen.starCitizen.enable = true;

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
