{ config, pkgs, lib, ...  }: with lib; 

{
	users.users.ark = {
		home = "/var/lib/ark";
		createHome = true;
		isSystemUser = true;
		group = "ark";
	};

	users.groups.ark = {};

	nixpkgs.config.allowUnfree = true;

	networking.firewall = {
		allowedUDPPorts = [ 7777 7778 27015];
		allowedTCPPorts = [ 27020 ];
	};

# -beta experimental \
	systemd.services.ark = {
		description = "Ark: Survival Evolved dedicated server";
		wants = [ "network-online.target" ];
		after = [ "syslog.target" "network.target" "nss-lookup.target" "network-online.target" ];

		preStart = ''
			${pkgs.steamcmd}/bin/steamcmd \
			+force_install_dir /var/lib/ark/ArkServer \
			+login anonymous \
			+app_update 376030 \
			validate \
			+quit
			'';

		script = ''
			/var/lib/ark/ArkServer/ShooterGame/Binaries/Linux/ShooterGameServer \
			TheIsland?listen?SessionName=Test-Server?ServerPassword=changeme?ServerAdminPassword=changeme1 -server -log
			'';

		serviceConfig = {
			User = "ark";
			Group = "ark";
			WorkingDirectory = "/var/lib/ark";
			LimitNOFILE = 100000;
		};

		wantedBy = [ "multi-user.target" ];
	};
}
