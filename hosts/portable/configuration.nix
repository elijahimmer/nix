{
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  mein = {
    eimmer = {
      headFull.enable = true;
      headFull.hyprland.withSwaylock = false;
      sshAccess = false;
    };

    networkManager.enable = false;
    syncthing.enable = false;
    tailscale.enable = false;

    pipewire.enable = true;
    theme.enable = true;
    ssot.enable = false;
  };

  environment.systemPackages = with pkgs; [acpi];

  users.users.eimmer.password = "";
  security.sudo.wheelNeedsPassword = false;

  services.clamav = lib.mkForce {
    daemon.enable = true;
    updater.enable = true;
  };

  services.openssh.enable = lib.mkForce false;

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
