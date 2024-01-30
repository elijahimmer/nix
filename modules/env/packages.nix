### THIS FILE IS AUTO GENERATED
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # AUTO GENERATED PACKAGE ADDER
    ### INSERT PACKAGES HERE
    btop
    conceal
    eza
    fd
    git
    just
    pciutils
    ripgrep
    magic-wormhole
    skim
    wget
    page
    p7zip
    #    socat
    #    jq
    gh

    killall
    # END AUTO GENERATION

    (pkgs.writeScriptBin "n" "nix-shell -p $@")
    (pkgs.writeScriptBin "nr" ''
      export NIX_SHELL_RUN_COMMAND=$@
      nix-shell -p "$1" --command ${pkgs.writeScript "nix-run-in-shell" ''
        $NIX_SHELL_RUN_COMMAND
        unset NIX_SHELL_RUN_COMMAND
      ''}
    '')
    (pkgs.writeScriptBin "ns" ''nix search --offline nixpkgs $@'')
    (pkgs.writeScriptBin "nse" ''nix search --offline nixpkgs '\.$1$' '')
  ];
}
