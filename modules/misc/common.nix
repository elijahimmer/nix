{
  pkgs,
  hostName,
  stateVersion,
  system,
  ...
}: {
  # needed to get flakes to work
  environment.systemPackages = with pkgs; [git];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = ["@wheel" "root"];
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8 days";
      persistent = true;
    };
    buildMachines = [
      {
        inherit system;
        # TODO: Find a better way to write this, like store the ssh public keys
        #       in a way the whole config can find
        sshKey = builtins.readFile ../../secrets/ssh-public-keys/server.pub;
        hostName = "server";
        maxJobs = 16;
      }
      {
        inherit system;
        sshKey = builtins.readFile ../../secrets/ssh-public-keys/desktop.pub;
        hostName = "desktop";
        maxJobs = 16;
      }
    ];
    distributedBuilds = true;

    daemonIOSchedClass = "best-effort";
    daemonCPUSchedPolicy = "batch";

    package = pkgs.nixUnstable;

    # From flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };

  networking = {inherit hostName;};
  system = {inherit stateVersion;};
}
