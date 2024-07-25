{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix

    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
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

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  security.polkit.enable = true;

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
