{
	description = "my flake ohh yea"; 
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		niri = {
			url = "github:sodiboo/niri-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};

	};

	outputs = {self, nixpkgs, home-manager, niri, ...}@inputs: {
		nixosConfigurations.amitay_btw = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = {inherit inputs;}; 
			modules = [
				./configuration.nix

				niri.nixosModules.niri
 
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true; 
					home-manager.extraSpecialArgs = {inherit inputs; };
					home-manager.users.amitay = import ./home.nix;
					home-manager.backupFileExtension = "backup";
				}
			];
		};
	};
}
