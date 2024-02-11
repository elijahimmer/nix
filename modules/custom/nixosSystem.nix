{inputs, ...}: let
  mods = inputs.self.nixosModules;
in {
  nixosSystem = {
    hostName,
    system ? "x86_64-linux",
    headFull ? false,
    useCommonModules ? true,
    useCommonExtendedModules ? useCommonModules,
    modules ? [],
    useCommonSpecialArgs ? true,
    specialArgs ? {},
    stateVersion ? "24.05",
    flakeAbsoluteDir ? "/home/eimmer/src/nix",
    other ? {},
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          ../../hosts/${hostName}/configuration.nix
        ]
        ++ (
          if useCommonModules
          then [
            inputs.home-manager.nixosModules.home-manager
            mods.common.default
            mods.env.default
            mods.eimmer.user
            mods.misc.networkmanager
            mods.ssot.age

            inputs.flake-utils-plus.nixosModules.autoGenFromInputs
            inputs.nixvim.nixosModules.nixvim
            inputs.agenix.nixosModules.default
          ]
          else []
        )
        ++ (
          if headFull
          then
            with mods; [
              inputs.stylix.nixosModules.stylix
              theme.default
              misc.pipewire
            ]
          else []
        )
        ++ (
          if useCommonExtendedModules
          then
            with mods; [
              env.coding
              misc.tailscale
              misc.syncthing
              misc.mullvad
            ]
          else []
        )
        ++ modules;
      specialArgs =
        {
          inherit inputs hostName headFull stateVersion system flakeAbsoluteDir mods;
        }
        // specialArgs;
    };
}
