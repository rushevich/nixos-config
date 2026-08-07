cur_flake := myMachine

build:
	nixos-rebuild build --flake .#${cur_flake}
switch:
	sudo nixos-rebuild switch --flake .#${cur_flake}	
new_generation:
	sudo nixos-rebuild switch --flake .#${cur_flake} && reboot
