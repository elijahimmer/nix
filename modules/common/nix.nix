{
  system,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    settings = {
      trusted-users = ["@wheel" "root"];
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8d";
      persistent = true;
    };
    /*
       I need to find a better way to do this.
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
    */
    # TODO: Fix distributed build to, you know, work
    #       I also need to find a way to make it optional,
    #       so that if they don't have a connection to one
    #       of the devices it doesn't fail
    #    distributedBuilds = true;

    daemonIOSchedClass = "best-effort";
    daemonCPUSchedPolicy = "batch";

    #package = pkgs.nixUnstable;
  };

  # TODO: Add auto upgrade again
  /*
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
  */
}
