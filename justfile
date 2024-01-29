alias t := test
alias s := switch
alias b := boot
alias u := update

test:
	git add .
	sudo nixos-rebuild test --flake .#$HOSTNAME
	nix fmt

boot:
	git add .
	sudo nixos-rebuild boot --flake .#$HOSTNAME
	nix fmt

switch: test
	git commit
	sudo nixos-rebuild switch --flake .#$HOSTNAME

update:
	git pull
	sudo nixos-rebuild switch --flake .#$HOSTNAME
