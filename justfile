alias t := test
alias s := switch
alias b := boot
alias u := update
alias uh := update-host
alias i := inputs
alias c := nix-check

default:
  @just --list

[group('nix')]
test:
    git add .
    git diff HEAD
    nh os test

[group('nix')]
boot:
    git add .
    git diff HEAD
    nh os boot

[group('nix')]
switch: nix-check 
    git add .
    git diff HEAD
    nix flake check --all-systems
    git commit 
    git push
    nh os switch

[group('nix-update')]
update:
    git pull
    git diff HEAD
    nh os switch

[group('nix-update')]
update-host HOST:
  nixos-rebuild switch --flake .#{{HOST}} --target-host {{HOST}} --build-host {{HOST}} --use-remote-sudo

[group('nix-update')]
inputs:
    git pull
    git diff HEAD
    nix flake update --commit-lock-file
    git diff HEAD~1
    nix flake check --all-systems
    nh os test
    git push
    nh os switch

[group('nix')]
nix-check:
    git add .
    git diff HEAD
    nix flake check --all-systems

