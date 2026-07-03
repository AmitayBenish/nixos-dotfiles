
{ config, lib, pkgs,inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;

   boot.loader.grub.efiSupport = false;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
   boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "amitay-btw"; 

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";


  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   i18n.extraLocaleSettings = {
		LC_PAPER = "he_IL.UTF-8";
		LC_TIME = "he_IL.UTF-8";
		LC_MEASUREMENT = "he_IL.UTF-8";
		LC_MONETARY = "he_IL.UTF-8";
	};


  


   services.printing.enable = true;
   security.rtkit.enable = true;
  # Enable sound.
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
   };


   users.users.amitay = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
   };
   nixpkgs.config.allowUnfree = true;
   programs.firefox.enable = true;
   nixpkgs.overlays = [inputs.niri.overlays.niri ];
   programs.niri.enable = true;
   programs.niri.package = pkgs.niri-unstable;
   
   programs.sway.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     helix 
     xwayland-satellite
     kdePackages.polkit-kde-agent-1
     alacritty
     yazi
     git
     gnumake
     gcc
   ];

     
   programs.steam = {
		enable =true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
		gamescopeSession.enable = true;
	};
  fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
   security.polkit.enable = true;
   systemd.user.services.polkit-kde-authentication-agent-1 = {
		description = "polkit-kde-authentication-agent-1";
		wantedBy = [ "graphical-session.target" ]; 
		wants = [ "graphical-session.target" ];
		after = [ "graphical-session.target" ];
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
			Restart = "on-failure"; 
			RestartSec = 1;
			TimeoutStopSec = 10;
		};  
	};
   hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = with pkgs; [
				rocmPackages.clr.icd
			];
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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
  system.stateVersion = "26.05"; # Did you read the comment?

}

