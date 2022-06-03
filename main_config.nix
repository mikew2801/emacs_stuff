# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport32Bit = config.hardware.opengl.enable;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [rtw89];

  networking.hostName = "nixbox"; # Define your hostname.
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_GB.UTF-8";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   console = {
     font = "Lat2-Terminus16";
     keyMap = "uk";
  };

  # Enable the X11 windowing system.

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    desktopManager.plasma5.enable = true;
    windowManager.exwm = {
      enable = true;
      enableDefaultConfig = false;
      extraPackages = epkgs: [
        epkgs.emacsql-sqlite
    ];
    };
    windowManager.openbox = { enable = true;};
};
    # Configure keymap in X11
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "ctrl:swapcaps";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.michael = {
     isNormalUser = true;
     password = "test";
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim 
     wget
     firefox
     emacs
     git
     dropbox
     neovim
     gparted
     pandoc
     tint2
     okular
     terminator
     qutebrowser
     dmenu
     libreoffice-fresh
     xfce.xfce4-whiskermenu-plugin
     xfce.xfwm4-themes
     xfce.xfce4-icon-theme
     mate.engrampa
     vlc
     rofi
     dmenu
     brave
     qbittorrent
     papirus-icon-theme
     zile
     lyx
     texlive.combined.scheme-full
     viewnior
     skypeforlinux
     wine
     silver-searcher
     masterpdfeditor
     #etcher
  ];

 fonts.fonts = with pkgs; [
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts
  dina-font
  proggyfonts
  ];

  nixpkgs.config.allowUnfree = true;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
  systemd.services.systemd-user-sessions.enable = false; #(after rebuild do rm /run/nologin)
}

