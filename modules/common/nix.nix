{
  system,
  pkgs,
  ...
}: {
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
    buildMachines = let
      machine = hostName: {
        inherit system hostName;
        sshUser = "builder";
        maxJobs = 16;
      };
    in [
      (machine "server")
      (machine "desktop")
    ];
    # TODO: Fix distributed build to, you know, work
    #    distributedBuilds = true;

    daemonIOSchedClass = "best-effort";
    daemonCPUSchedPolicy = "batch";

    package = pkgs.nixUnstable;

    # From flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:elijahimmer/nix";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "daily";
    randomizedDelaySec = "45min";
    persistent = true;
  };
}
