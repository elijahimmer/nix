t: test waybar
s: switch
b: boot

test:
	git add .
	sudo nixos-rebuild test --flake .#$$HOSTNAME
	nix fmt

boot:
	git add .
	sudo nixos-rebuild boot --flake .#$$HOSTNAME
	nix fmt

switch: test waybar
	git commit
	sudo nixos-rebuild switch --flake .#$$HOSTNAME

waybar:
	# Needed after build, nix starts it incorrectly for some reason.
	# TODO! fix this issue
	#systemctl --user restart waybar.service
	# disable this while messing with eww

