{
  hostName,
  config,
  lib,
  ...
}: let
  devices = {
    helios = "PVNDSAB-HQOHR66-TC33BUM-SKJKQUB-BQF72YE-SYY5IW2-OHBCY4C-DP5X4Q4";
    gaea = "H4RMB5K-XW2FISQ-MYUHCSD-WTEXEII-IHBX7AB-NH4I32H-TWJUZKR-YTRBLAS";
    selene = "7TYNNXG-TSZHVWS-KEKAVKS-NZMPOOF-2RSX7AP-U4PIENU-4WKCWO6-5GPHZAA";
  };
  cfg = config.mein.syncthing;
in
  with lib; {
    options.mein.syncthing = {
      enable = mkEnableOption "enable syncthing" // {default = config.mein.env.enable;};
      user = mkOption {
        type = types.str;
        default = "eimmer";
      };
      dataDir = mkOption {
        type = types.str;
        default = "/home/${cfg.user}/Documents";
      };
      folders = mkOption {
        type = types.listOf types.str;
        default = ["Documents"];
      };
    };

    config = mkIf cfg.enable {
      services.syncthing = {
        inherit (cfg) dataDir user;
        enable = true;
        configDir = "/home/${cfg.user}/.config/syncthing";

        openDefaultPorts = true;
        overrideFolders = true;
        overrideDevices = true;

        settings = {
          id = devices.${hostName};

          localAnnounceEnabled = false;
          relaysEnabled = false;

          folders = foldr (id: acc:
            acc
            // {
              ${id} = {
                inherit id;
                path = "/home/${cfg.user}/${id}";
                devices = ["helios" "gaea" "selene"];
              };
            }) {}
          cfg.folders;
          devices = let
            dev = hn: {
              id = devices.${hn};
              address = ["tcp://${hn}"];
            };
          in {
            helios = dev "helios";
            gaea = dev "gaea";
            selene = dev "selene";
          };
          options.urAccepted = -1;
        };
      };
    };
  }
