#!/bin/sh -x

sudo nixos-rebuild test --flake .#$HOSTNAME && nix fmt && bash
