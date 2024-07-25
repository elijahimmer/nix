{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix

    common-cpu-intel
    common-gpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  mein = {
    eimmer.headFull.enable = true;
    env.withCodingPkgs = true;
    pipewire.enable = true;
    theme.enable = true;
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    acpi
  ];

  services.btrfs.autoScrub.enable = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  security.polkit.enable = true;

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
