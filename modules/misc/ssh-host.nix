{lib, ...}: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkForce "no";
    };

    openFirewall = lib.mkForce true;
  };
  users.users.eimmer.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtGu3F4RIogpoh5cai+8+kF6Ec8WJoM+1UfpmqPLB7v eimmer@lv14"
  ];
}
