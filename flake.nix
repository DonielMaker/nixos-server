{
	description = "System Configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

		disko.url = "github:nix-community/disko";
		disko.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = {
		self,
		nixpkgs,
		nixpkgs-unstable,
		disko,
		... 
	}@inputs : 

	let
		system = "x86_64-linux";
	in 

	{
		nixosConfigurations.nixgamer = nixpkgs.lib.nixosSystem {
			specialArgs = {
				pkgs-unstable = import nixpkgs-unstable {
					inherit system;
					config.allowUnfree = true;	
				};
				inherit inputs system;
			};
			modules = [ 
				./configuration.nix 
				disko.nixosModules.disko
			];
		};

	};
}
