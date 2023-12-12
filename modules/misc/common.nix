{
  pkgs,
  hostName,
  stateVersion,
  ...
}: {
  # needed to get flakes to work
  environment.systemPackages = with pkgs; [git];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";

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
