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
    aphrodite = "GEWSXJQ-V3SYTW6-B4HWKMC-36QEGL5-H7JMTNI-QMFKKCN-ILD5SC4-6C5Y4QX";
  };
  cfg = config.mein.syncthing;
in
  with lib; {
    options.mein.syncthing = {
      enable = mkEnableOption "enable syncthing";
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
      guiEnabled = mkOption {
        type = types.bool;
        default = false;
      };
    };

    config = mkIf cfg.enable {
      assertions = [
        {
          assertion = builtins.hasAttr config.networking.hostName devices;
          message = "host `${config.networking.hostName}` doesn't have a device ID.";
        }
      ];

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
                devices = ["helios" "gaea" "selene" "aphrodite"];
                versioning = {
                  type = "staggered";
                  params = {
                    cleanInterval = "3600";
                    maxAge = "31536000";
                  };
                };
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
            aphrodite = dev "aphrodite";
          };
          gui.enabled = cfg.guiEnabled;
          options.urAccepted = -1;
        };
      };
    };
  }
