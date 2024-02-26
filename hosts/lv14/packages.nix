{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    acpi
    firefox

    # AUTO GENERATED PACKAGE ADDER
    ### INSERT PACKAGES HERE

    # END AUTO GENERATION
  ];
}
