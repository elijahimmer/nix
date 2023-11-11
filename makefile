
t:
	sudo nixos-rebuild test --flake .#$$HOSTNAME && nix fmt && bash
test: t

s:
	sudo nixos-rebuild test --flake .#$$HOSTNAME
	nix fmt
	git add .
	git commit
	sudo nixos-rebuild switch --flake .#$$HOSTNAME && bash
switch: s

