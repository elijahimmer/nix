{
  config,
  pkgs,
  inputs,
  hostname,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix
    ./packages.nix

    users.eimmer
    users.eimmer.desktop

    profiles.tailscale
    profiles.fail2ban
    profiles.wireless
    profiles.pipewire
    profiles.avahi

    misc.environment
    misc.v4l2loopback
    misc.bluetooth
    misc.common
    misc.gc
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
      headless = false;
    };
  };

  users.users.eimmer.extraGroups = ["video"];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angelese";
  location.provider = "geoclue2";

  nix = {
    # From flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };

  networking = {
    inherit hostname;
    wireless.enable = true;
  };

  boot = {
    tmp.useTmpfs = true;
    loader = {
      grub = {
        memtest86.enable = true;
        enableCryptodisk = true;
        timeoutStyle = "hidden";
        efiSupport = true;
        device = "nodev";
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
    initrd.secrets = {"/luks.key" = /luks.key;};
    plymouth.enable = true;
  };
  polkit.enable = true;

  system.stateVersion = "23.11";
}
