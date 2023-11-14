
t:
	git add .
	sudo nixos-rebuild test --flake .#$$HOSTNAME
	nix fmt

s:
	git add .
	sudo nixos-rebuild test --flake .#$$HOSTNAME
	nix fmt
	git commit
	sudo nixos-rebuild switch --flake .#$$HOSTNAME

switch: s
test: t
