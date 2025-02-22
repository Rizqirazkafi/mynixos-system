# et:s Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, pkgs-unstable, stylix, ... }:

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
    # ./nginx-simple.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
    # ./moodle.nix
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

  # for virt-manager
  programs.file-roller.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.plymouth.catppuccin.enable = true;
  boot.plymouth.catppuccin.flavor = "mocha";

  networking.hostName = "nixos-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.hosts = {
    "127.0.0.1" = [ "phpdemo.myhome.local" "myhome.local" "moodle.local" ];
    "192.168.30.20" = [ "personal-cloud.local" ];
    "192.168.192.124" = [ "personal-cloud.local" ];
  };

  programs.dconf.enable =
    true; # virt-manager requires dconf to remember settings
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Enable noise torch
  # programs.noisetorch.enable = true;

  # Enable legacy PPTP module
  services.pptpd.enable = true;

  # Enable zerotier
  # services.zerotierone.enable = true;
  # services.zerotierone.port = 9993;

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
  services.xserver.dpi = 96;

  # Enable the LXQT Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.lightdm.background =
  #   ../wallpaper/nixos-wallpaper-catppuccin-mocha.png;
  # services.xserver.displayManager.lightdm.greeters.gtk.extraConfig =
  #   "user-background = false";
  # services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  # services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "rose-pine";
  # services.xserver.displayManager.lightdm.greeters.gtk.iconTheme.name =
  #   "rose-pine";
  # SDDM
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    catppuccin = {
      enable = true;
      flavor = "mocha";
      font = "TerminesNerdFont-Regular";
    };
  };
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
  # sound.enable = true;
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
      "adbusers"
    ];
    packages = with pkgs; [
      inputs.zen-browser.packages."${system}".default
      firefox
      nextcloud-client
      #  thunderbird
    ];
    homeMode = "755";
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
  environment.variables = { };
  programs.bash.shellInit = ''
    export LS_COLORS+=":ow=01;33";
  '';
  programs.light.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      xfce4-whiskermenu-plugin
    ];
  };
  # environment.shellInit = ''
  #   [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
  # '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs-unstable.zoom-us
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ripgrep
    htop
    mission-center
    fastfetch
    unzip
    stow
    lm_sensors
    arandr
    wget
    interception-tools
    git
    xclip
    gnome-keyring
    nautilus
    adwaita-icon-theme
    gnome-shell
    polkit_gnome
    alacritty
    gcc.cc.libgcc
    gcc_multi
    python3
    i3
    i3status
    libnotify # Notification daemon
    light
    playerctl
    pamixer
    rofi
    google-chrome
    pkgs-unstable.picom
    nitrogen
    bridge-utils
    libvirt
    pcmanfm
    # lxappearance
    # ventoy-full
    vlc
    mpv
    # mplayer
    zathura
    # marp-cli
    terminus_font
    terminus_font_ttf
    # nerdfonts
    # terminus-nerdfont
    # fira-code-nerdfont
    jq
    # Graphics and Video
    flameshot # screenshot tool
    nomacs # image viewer
    gimp
    # Office Suite
    # python312Packages.pygments
    # inputs.own-texlive.legacyPackages.${system}.texliveFull
    # beamerpresenter
    libreoffice-fresh
    # onlyoffice-bin_latest
    # Networking
    pkgs-unstable.winbox4
    scrcpy
    pkgs-unstable.android-tools
    pptp
    ppp
    nmap
    netcat-gnu # read write data via net
    inetutils
    vnstat # monitor network
    # (gns3-gui.overrideAttrs (oldAttrs: rec { src = inputs.gns3-gui; }))
    # my-gns3-gui
    pkgs-unstable.gns3-gui
    pkgs-unstable.gns3-server
    ubridge
    dynamips
    sshfs
    remmina
    gnomeExtensions.remmina-search-provider
    # distrobox
    transmission-gtk
    # rclone
    # Add polkit for distrobox
    zenity
    xorg.xhost
    # Tool for Nvidia
    lshw
    nvtopPackages.nvidia
    mediainfo
    # themes
    # libsForQt5.qtstyleplugin-kvantum
    # libsForQt5.qt5ct
    # theme-obsidian2
    # Programming and stuff
    # go
    # gofumpt
    # nasm
    gnumake
    # Audio
    easyeffects
    qpwgraph
    obs-studio
    pavucontrol
    # Development
    android-studio
    flutter
    dart
    cmake # require for flutter
    ninja # require for flutter
    clang # require for flutter
    pkg-config # require for flutter
    # Education
    # etc
    openssl
    gparted
    polkit
    xdotool
    baobab
    # wineWowPackages.stable
    # winetricks
    # xorg.xkill
    # ueberzug
  ];
  programs.adb.enable = true;
  programs.nix-ld.enable = true;
  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "Terminus" ]; }) ];

  # Enable docker with rootles
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      data-root = "/home/rizqirazkafi/secondssd/ISO/docker";
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

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

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
  xdg.mime.defaultApplications = {
    "application/octet-stream" = "cisco-pt8.desktop.desktop";
  };
  # Fix password prompt for nm-applet
  services.gnome.gnome-keyring.enable = true;
  # Workarround for GNS3 ubridge
  security.wrappers.ubridge = {
    source = "/run/current-system/sw/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "rizqirazkafi";
    group = "users";
    permissions = "u+rx,g+x";
  };
}
