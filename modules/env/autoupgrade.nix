{inputs, updateFromScratch ? false, ...}:{
  system.autoUpgrade = {
    enable = true;
    flake = 
      if updateFromScratch
      then "github:elijahimmer/nix"
      else inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

}
