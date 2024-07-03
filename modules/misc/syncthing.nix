{hostName,...}: 
  let
    devices = {
      desktop = "R4GYGQ3-LSWYBOA-5FZAEOM-CLIB75Y-ZNGRR47-IBB3XYG-TQYETOE-N4I3VQ5";
      lv14 = "3LGCXEU-2UGN6FO-U5DEGRU-6Q3EFQH-OW2TDSI-WYQCTG7-PX77TZ2-BZ362QP";
      server = "EW5UR76-JRBXC56-RYIPW3Z-2O2UZ6V-M2VF2GT-UT4VYVX-DHJWO2W-WBEP2QW";
    };
  in
{ 
  services.syncthing = {
    group = "eimmer-home";
    enable = true;
    openDefaultPorts = true;
    overrideFolders = true;
    overrideDevices = true;
    settings = {
      id = devices.${hostName};
      folders = {
        "/home/eimmer/Documents" = {
          id = "Documents";
          devices = ["desktop" "lv14"];
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
        };
      };
      options.urAccepted = -1;
    };
  };
}
