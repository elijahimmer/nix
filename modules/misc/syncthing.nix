{hostName,config,inputs,...}: 
  let
    devices = {
      desktop = "H4RMB5K-XW2FISQ-MYUHCSD-WTEXEII-IHBX7AB-NH4I32H-TWJUZKR-YTRBLAS";
      lv14 = "7TYNNXG-TSZHVWS-KEKAVKS-NZMPOOF-2RSX7AP-U4PIENU-4WKCWO6-5GPHZAA";
      server = "PVNDSAB-HQOHR66-TC33BUM-SKJKQUB-BQF72YE-SYY5IW2-OHBCY4C-DP5X4Q4";
    };
  in
{ 
  #age.secrets.syncthingUsername = inputs.self + /secrets/syncthing-username.age;
  #age.secrets.syncthingPassword = inputs.self + /secrets/syncthing-password.age;
  services.syncthing = {
    enable = true;
    user = "eimmer";
    dataDir = "/home/eimmer/Documents";    # Default folder for new synced folders
    configDir = "/home/eimmer/.config/syncthing";

    openDefaultPorts = true;
    overrideFolders = true;
    overrideDevices = true;

    #services.syncthing.settings.gui = {
    #    user = config.age;
    #    password = config.age.secrets.syncthing;
    #};

    settings = {
      id = devices.${hostName};

      folders = {
        "Documents" = {
          id = "Documents";
          path = "/home/eimmer/Documents";
          devices = ["desktop" "lv14" "server"];
        };
      };
      devices = {
        desktop = {
          id = devices.desktop;
          addresses = ["tcp://desktop"];
        };
        lv14 = {
          id = devices.lv14;
          addresses = ["tcp://lv14"];
        };
        server = {
          id = devices.server;
          addresses = ["tcp://server"];
          remoteGUIPort = 8384;
        };
      };
      options.urAccepted = -1;
    };
  };
}
