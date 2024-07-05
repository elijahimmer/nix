{hostName,...}: 
  let
    devices = {
      helios = "PVNDSAB-HQOHR66-TC33BUM-SKJKQUB-BQF72YE-SYY5IW2-OHBCY4C-DP5X4Q4";
      gaea = "H4RMB5K-XW2FISQ-MYUHCSD-WTEXEII-IHBX7AB-NH4I32H-TWJUZKR-YTRBLAS";
      selene = "7TYNNXG-TSZHVWS-KEKAVKS-NZMPOOF-2RSX7AP-U4PIENU-4WKCWO6-5GPHZAA";
    };
  in
{ 
  services.syncthing = {
    enable = true;
    user = "eimmer";
    dataDir = "/home/eimmer/Documents";    # Default folder for new synced folders
    configDir = "/home/eimmer/.config/syncthing";

    openDefaultPorts = true;
    overrideFolders = true;
    overrideDevices = true;

    settings = {
      id = devices.${hostName};

      folders = {
        "Documents" = {
          id = "Documents";
          path = "/home/eimmer/Documents";
          devices = ["helios" "gaea" "selene"];
        };
      };
      devices = {
        helios = {
          id = devices.helios;
          addresses = ["tcp://helios"];
        };
        gaea = {
          id = devices.gaea;
          addresses = ["tcp://gaea"];
        };
        selene = {
          id = devices.selene;
          addresses = ["tcp://selene"];
        };
      };
      options.urAccepted = -1;
    };
  };
}
