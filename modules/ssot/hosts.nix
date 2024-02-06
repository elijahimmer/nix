{
  desktop = {
    publicSshKeyFile = ./ssh/desktop.pub;
    syncthing = ./syncthing/desktop.cert.pem;
  };
  server = {
    publicSshKeyFile = ./ssh/server.pub;
    syncthing = ./syncthing/server.cert.pem;
  };
  lv14 = {
    publicSshKeyFile = ./ssh/lv14.pub;
    syncthing = ./syncthing/lv14.cert.pem;
  };
}
