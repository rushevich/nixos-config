laptop-bld:
	nixos-rebuild build --flake .#platinum
laptop-swtch:
	sudo nixos-rebuild switch --flake .#platinum	
laptop-ng:
	sudo nixos-rebuild switch --flake .#platinum && reboot

desktop-bld:
	nixos-rebuild build --flake .#cobalt
desktop-swtch:
	sudo nixos-rebuild switch --flake .#cobalt	
desktop-ng:
	sudo nixos-rebuild switch --flake .#cobalt && reboot
