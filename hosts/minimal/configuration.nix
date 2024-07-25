_: {
  mein = {
    ssot.enable = false;
    env = {
      withPkgs = false;
      withTailscale = false;
    };
    sshAccess = false;
  };

  boot = {
    tmp.useTmpfs = true;
    loader = {
      grub = {
        memtest86.enable = true;
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
