{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    jdk11
    acpi
    firefox
    google-java-format

    # AUTO GENERATED PACKAGE ADDER
    ### INSERT PACKAGES HERE

    # END AUTO GENERATION
  ];
}
