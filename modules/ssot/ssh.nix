{mods, ...}: {
  services.openssh.knownHosts = with mods.ssot.hosts; {
    desktop.publicKeyFile = desktop;
    lv14.publicKeyFile = lv14;
    server.publicKeyFile = server;
  };
}
