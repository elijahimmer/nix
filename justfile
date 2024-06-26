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
    git diff HEAD
    sudo nixos-rebuild boot --flake .#$HOSTNAME

switch: nix-check 
    git add .
    git diff HEAD
    git commit
    git push
    sudo nixos-rebuild switch --flake .#$HOSTNAME

update:
    git pull
    git diff HEAD
    sudo nixos-rebuild switch --flake .#$HOSTNAME

inputs:
    git pull
    git diff HEAD
    nix flake update
    date +"%s" > updated_last
    @just switch

nix-check:
    git add .
    git diff HEAD
    nix flake check --all-systems

test-inputs:
    nix flake update
    @just test 
