# et:s Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nbfc.nix
    ./vim.nix
    # ./nvidia.nix
    ./nvidia-powersave.nix
    ./virt-manager.nix
    ./file-system.nix
    # ./overlays.nix
    ./auto-cpufreq.nix
    # ./nginx.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
    # ./moodle.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "rizqirazkafi" ];
  nix.package = pkgs.nixFlakes;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
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

  # for virt-manager
  programs.file-roller.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "kvm-intel" "ppp_mppe" "pptp" ];
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  networking.hostName = "nixos"; # Define your hostname.
  networking.hosts = {
    "127.0.0.1" = [ "phpdemo.myhome.local" "myhome.local" "moodle.local" ];
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Enable noise torch
  programs.noisetorch.enable = true;

  # Enable legacy PPTP module
  networking.firewall.connectionTrackingModules = [ "pptp" "snmp" ];
  services.pptpd.enable = true;

  # Enable zerotier
  services.zerotierone.enable = false;
  services.zerotierone.port = 9993;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";
  time.hardwareClockInLocalTime = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.dpi = 75;

  # Enable the LXQT Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.background =
    ../wallpaper/nixos-wallpaper-catppuccin-mocha.png;
  services.xserver.displayManager.lightdm.greeters.gtk.extraConfig =
    "user-background = false";
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "rose-pine";
  services.xserver.displayManager.lightdm.greeters.gtk.iconTheme.name =
    "rose-pine";
  services.xserver = {
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
      ];
      updateSessionEnvironment = true;
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = true;
      };
      lxqt = { enable = false; };
    };
  };

  # Enable flatpak
  services.flatpak.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = { layout = "us"; };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rizqirazkafi = {
    isNormalUser = true;
    description = "rizqirazkafi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
      "dialout"
      "ubridge"
      "kvm"
      "wireshark"
      "docker"
      "nginx"
    ];
    packages = with pkgs;
      [
        firefox
        #  thunderbird
      ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.qt5 = {
    enable = true;
    platformTheme = "qt5ct";
    style = {
      package = pkgs.utterly-nord-plasma;
      name = "Utterly Nord Plasma";
    };
  };
  environment.variables = {
    # GDK_SCALE = "0.3";
    # GDK_DPI_SCALE = "1";
    # Scale QT Application e.g: VirtualBox
    # QT_AUTO_SCREEN_SET_FACTOR = "0";
    # QT_SCALE_FACTOR = "1.5";
    # QT_FONT_DPI = "96";
    SUDO_ASKPASS = "/home/rizqirazkafi/.local/bin/password-prompt";
  };
  environment.variables.QT_QPA_PLATFORMTHEME = "kvantum";
  qt.style = "kvantum";
  programs.light.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      xfce4-whiskermenu-plugin
    ];
  };
  environment.shellInit = ''
    [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ripgrep
    htop
    neofetch
    fastfetch
    unzip
    stow
    lm_sensors
    auto-cpufreq # manage power
    arandr
    wget
    interception-tools
    git
    xclip
    gnome.gnome-keyring
    gnome.nautilus
    gnome.adwaita-icon-theme
    gnome.gnome-shell
    polkit_gnome
    alacritty
    gcc.cc.libgcc
    gcc_multi
    python3
    rose-pine-gtk-theme
    rose-pine-icon-theme
    i3
    i3status
    libnotify # Notification daemon
    light
    playerctl
    pamixer
    rofi
    google-chrome
    picom
    nitrogen
    virt-manager
    bridge-utils
    libvirt
    qemu
    qemu_kvm
    pcmanfm
    lxappearance
    # ventoy-full
    vlc
    mpv
    # mplayer
    zathura
    marp-cli
    terminus_font
    terminus_font_ttf
    # nerdfonts
    # terminus-nerdfont
    # fira-code-nerdfont
    flatpak
    jq
    # Graphics and Video
    flameshot # screenshot tool
    nomacs # image viewer
    gimp
    # Office Suite
    python312Packages.pygments
    inputs.own-texlive.legacyPackages.${system}.texliveFull
    inputs.nixpkgs-unstable.legacyPackages.${system}.libreoffice
    beamerpresenter
    libreoffice
    # Networking
    pptp
    ppp
    winbox
    tigervnc
    x11vnc
    ansible
    nmap
    netcat-gnu # read write data via net
    inetutils
    vnstat # monitor network
    gns3-gui
    gns3-server
    ubridge
    dynamips
    tigervnc
    sshfs
    #ciscoPacketTracer8
    remmina
    gnomeExtensions.remmina-search-provider
    distrobox
    # rclone
    # Add polkit for distrobox
    gnome.zenity
    xorg.xhost
    # Tool for Nvidia
    lshw
    # nvtopPackages.full
    mediainfo
    # themes
    # libsForQt5.qtstyleplugin-kvantum
    # libsForQt5.qt5ct
    # theme-obsidian2
    # Programming and stuff
    arduino
    arduino-cli
    # kicad
    # go
    # gofumpt
    # nasm
    gnumake
    # Audio
    # noisetorch
    easyeffects
    qpwgraph
    obs-studio
    pavucontrol
    # Deployment
    # flutter
    # dart
    # etc
    openssl
    gparted
    polkit
    xdotool
    baobab
    zoom-us
    wineWowPackages.stable
    winetricks
    discord
    xorg.xkill
    # ueberzug
    goverlay # displayFPS
    mangohud
  ];

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "Terminus" ]; }) ];

  # Enable docker with rootles

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
    # guest = {
    #   enable = true;
    #   x11 = true;
    # };
  };
  users.extraGroups.vboxusers.members = [ "rizqirazkafi" ];

  # Swap capslock with Escape and Ctrl key
  services.interception-tools = {
    enable = true;
    plugins = with pkgs; [ interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 0 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

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
  security.pam.sshAgentAuth.enable = true;
  # Open ports in the firewall.
  #	networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # services.pipewire.wireplumber.enable = true;
  # Monitor network usage
  services.vnstat.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  security = { polkit.enable = true; };
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
    lxqt.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-xapp pkgs.xdg-desktop-portal-gtk ];
    config = { common = { default = [ "xapp" "gtk" ]; }; };
  };
  # systemd = {
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart =
  #         "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };

  # Workarround for GNS3 ubridge

  security.wrappers.ubridge = {
    source = "/run/current-system/sw/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "rizqirazkafi";
    group = "users";
    permissions = "u+rx,g+x";
  };

}
