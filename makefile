
t:
	sudo nixos-rebuild test --flake .#$$HOSTNAME && nix fmt && bash
test: t

s:
	git add . && git commit && nix fmt && sudo nixos-rebuild switch --flake .#$$HOSTNAME && bash
switch: s

