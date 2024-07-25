{mods, ...}: {
  services.openssh.knownHosts = with mods.ssot.hosts; {
    helios.publicKeyFile = helios.publicSshKeyFile;
    gaea.publicKeyFile = gaea.publicSshKeyFile;
    selene.publicKeyFile = selene.publicSshKeyFile;
  };
}
