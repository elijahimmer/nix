{
  services.openssh.knownHosts = {
    desktop.publicKeyFile = ../../secrets/ssh-public-keys/desktop.pub;
    lv14.publicKeyFile = ../../secrets/ssh-public-keys/lv14.pub;
    server.publicKeyFile = ../../secrets/ssh-public-keys/server.pub;
  };
}
