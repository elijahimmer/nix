alias t := test
alias s := switch
alias b := boot
alias u := update
alias i := inputs
alias c := nix-check
alias ti := test-inputs

test:
    git add .
    git diff HEAD
    sudo nixos-rebuild test --flake .#$HOSTNAME

boot:
    git add .
    sudo nixos-rebuild boot --flake .#$HOSTNAME

switch: nix-check 
    git diff HEAD
    git commit
    sudo nixos-rebuild switch --flake .#$HOSTNAME

update:
    git pull
    sudo nixos-rebuild switch --flake .#$HOSTNAME

inputs:
    git pull
    nix flake update
    @just switch

nix-check:
    git add .
    nix flake check --all-systems

test-inputs:
    nix flake update
    @just test 
