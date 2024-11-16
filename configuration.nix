# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		./disko.nix

		./ark.nix
		];

# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

# Allow Flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	networking.hostName = "nixgamer"; # Define your hostname.
# Pick only one of the below networking options.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
		networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

# Set your time zone.
		time.timeZone = "Europe/Berlin";

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.donielmaker = {
		isNormalUser = true;
		extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
		openssh.authorizedKeys.keyFiles = [
			./id_rsa.pub
		];
	};

	environment.systemPackages = with pkgs; [
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		git
		curl
		htop
		steamcmd
	];

	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
		};
	};

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# to actually do that.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.05"; # Did you read the comment?

}

