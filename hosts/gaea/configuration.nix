{
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix

    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc
    common-pc-ssd
  ];

  mein = {
    eimmer.headFull.enable = true;
    env.withCodingPkgs = true;
    pipewire.enable = true;
    pipewire.noisetorch.enable = true;
    music.enable = true;
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
