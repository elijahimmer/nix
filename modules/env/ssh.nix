{mods, ...}: {
  services.openssh.knownHosts = with mods.ssot.hosts; {
    desktop.publicKeyFile = desktop.publicSshKeyFile;
    lv14.publicKeyFile = lv14.publicSshKeyFile;
    server.publicKeyFile = server.publicSshKeyFile;
  };
}
