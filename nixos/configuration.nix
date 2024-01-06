#et:s Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nbfc.nix
      ./vim.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
      set-option -sa terminal-overrides ",xterm*:Tc"
      # bind <C-Alt-*> to move arround windows
      bind -n C-M-H next-window
      bind -n C-M-L previous-window
      # Set prefix to <C-Space>
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix
      set -g mouse
    '';
    plugins = with pkgs.tmuxPlugins ; [
      vim-tmux-navigator
      sensible
    ];
  };

  # Nvidia Specific
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`. nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # virtualisation.docker.enable = true;
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };
  # for virt-manager
  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" ];
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];

      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  programs.file-roller.enable = true;


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "kvm-intel" "ppp_mppe" "pptp" ];
  fileSystems."/home/rizqirazkafi/winssd" =
    {
      device = "/dev/nvme0n1p3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };
  fileSystems."/home/rizqirazkafi/secondssd" =
    {
      device = "/dev/nvme1n1p3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.hosts = {
  #   "ip-address" = ["domain"];
  # };
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
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "abfd31bd4787082d" ];
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

  # Enable the LXQT Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "rose-pine";
  services.xserver.displayManager.lightdm.greeters.gtk.iconTheme.name = "rose-pine";
  services.xserver = {
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
      ];
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
      lxqt = {
        enable = false;

      };
    };
  };

  # Enable flatpak
  services.flatpak.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

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
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" "video" "dialout" ];
    packages = with pkgs; [
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
  environment.variables.QT_QPA_PLATFORMTHEME = "kvantum";
  qt.style = "kvantum";
  programs.light.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce;[
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ripgrep
    htop
    neofetch
    unzip
    stow
    lm_sensors
    arandr
    wget
    interception-tools
    git
    xclip
    gnome.gnome-keyring
    gnome.nautilus
    gnome.adwaita-icon-theme
    polkit_gnome
    alacritty
    gcc.cc.libgcc
    gcc_multi
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
    virtualbox
    pcmanfm
    lxappearance
    ventoy-full
    vlc
    mpv
    mplayer
    zathura
    terminus_font
    terminus_font_ttf
    flatpak
    # Graphics and Video
    flameshot # screenshot tool
    nomacs # image viewer
    gimp
    # Office Suite
    texlab
    ltex-ls
    texlive.combined.scheme-full
    libreoffice
    # Networking
    pptp
    ppp
    winbox
    tigervnc
    ansible
    zerotierone
    nmap
    netcat-gnu # read write data via net
    inetutils
    vnstat #monitor network
    gns3-gui
    gns3-server
    ciscoPacketTracer8
    # Tool for Nvidia
    lshw
    nvtop
    mediainfo
    # themes
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    theme-obsidian2
    # Programming and stuff
    arduino
    arduino-cli
    kicad
    # Audio
    noisetorch
    qpwgraph
    obs-studio
    pavucontrol
    # Deployment
    docker
    docker-compose
    #flutter
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
    ueberzugpp
    xorg.xkill

  ];
  # Swap capslock with Escape and Ctrl key
  services.interception-tools = {
    enable = true;
    plugins = with pkgs; [
      interception-tools-plugins.caps2esc
    ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
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
  services.openssh.enable = true;

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

  security = {
    polkit.enable = true;
  };
  xdg.portal.lxqt.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

}
