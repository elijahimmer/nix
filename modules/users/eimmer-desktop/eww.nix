{
  lib,
  pkgs,
  inputs,
  ...
}: let
  eww-pkg =
    pkgs.writeShellScriptBin "eww" "${lib.getExe pkgs.eww-wayland} -c ${./eww} $@";
in {
  environment.systemPackages = [
    inputs.eww-workspaces.packages.x86_64-linux.default
    eww-pkg
  ];
}
