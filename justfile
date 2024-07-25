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
    nh os test

boot:
    git add .
    git diff HEAD
    nh os boot

switch: nix-check 
    git add .
    git diff HEAD
    git commit 
    git push
    nh os switch

update:
    git pull
    git diff HEAD
    nh os switch

inputs:
    git pull
    git diff HEAD
    nix flake update
    date +"%s" > updated_last
    @just switch

nix-check:
    git add .
    git diff HEAD
    nh os test --dry

test-inputs:
    nix flake update
    @just test 
