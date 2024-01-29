let
  lv14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtGu3F4RIogpoh5cai+8+kF6Ec8WJoM+1UfpmqPLB7v";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH0a9pghHok8USAlicO8tV1R11Uc/yt2nP0/O1D9rkme";
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEakFUBElt2EvXqqAsw6zGV8Bu6+0AQLDgOAU4PcigWR";
  themAll = [lv14 server desktop];
in {
  "lv14-ssh.age".publicKeys = [lv14];
  "server-ssh.age".publicKeys = [server];
  "desktop-ssh.age".publicKeys = [desktop];
  "eimmer-passwd.age".publicKeys = themAll;
}
