{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    jdk11
    acpi
    firefox
    google-java-format
  ];
}
