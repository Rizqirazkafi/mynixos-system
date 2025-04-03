# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./filesystem.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "rizqirazkafi" ];
  nix.package = pkgs.nixVersions.stable;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users.rizqirazkafi = import ../home.nix;
  };
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -sa terminal-overrides ",alacritty:RGB"
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix
      set -g mouse
    '';
    plugins = with pkgs.tmuxPlugins; [ sensible vim-tmux-navigator ];
    terminal = "screen-256color";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rizqi-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  programs.dconf.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.interfaces.ens18 = {
    ipv4.addresses = [{
      address = "192.168.30.20";
      prefixLength = 25;
    }];
  };
  networking.nameservers = [ "172.30.30.1" "1.1.1.1" "8.8.8.8" ];
  networking.defaultGateway = {
    address = "192.168.30.1";
    interface = "ens18";
  };

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";
  # xserver
  services.xserver.enable = true;
  services.xserver.desktopManager = {
    xterm.enable = false;
    xfce.enable = true;
  };
  services.displayManager.defaultSession = "xfce";
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startxfce4";
  services.xrdp.openFirewall = true;
  services.guacamole-server = {
    enable = true;
    host = "127.0.0.1";
    userMappingXml = ../guacamole/user-mapping.xml;
  };
  services.guacamole-client = {
    enable = true;
    enableWebserver = true;
    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.1";
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "id_ID.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "id_ID.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "id_ID.UTF-8";
  };

  # Configure keymap in X11
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rizqirazkafi = {
    isNormalUser = true;
    description = "rizqirazkafi";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    htop
    fastfetch
    unzip
    ripgrep
    fd
    firefox
    winbox4
    google-chrome
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  ## Nextcloud services 
  environment.etc."nextcloud-admin-pass".text = "PWD";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "personal-cloud.local";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    # datadir = "/home/rizqirazkafi/secondhdd/data";
  };
  services.qemuGuest.enable = true;
  virtualisation.docker = { enable = true; };
  # Enable zerotier
  services.zerotierone.enable = true;
  services.zerotierone.port = 9993;

}
