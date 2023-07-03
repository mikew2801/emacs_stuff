# This is the configuration shared by all machines
# There must be a hardware configuration in the /etc/nixos/ local folder and a file named after the host available in the same dropbox directory as this file
# sudo cp 1_main_nix.nix /etc/nixos/configuration.nix

# Consider adding gphoto2, gphoto2fs, and digikam to the package manifest

{ config, pkgs, lib, ... }:

# Change the second import here to correspond to the machine you’re updating

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./worknix.nix
    ];
  
  boot.loader.grub.default = "saved";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

   hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = config.hardware.opengl.enable;
    };
  };

  # Always get the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.extraModulePackages = with config.boot.kernelPackages; [rtw89];
  #boot.kernelPackages = pkgs.linuxKernel.kernels.linux_5_19;
  #boot.kernelPackages = pkgs.linuxPackages_testing;
  #boot.kernelPackages = pkgs.linuxPackages_5_19;
  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_19;

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

  #services.tlp.enable = true;
  services.emacs.install = true;
  services.blueman.enable = true;

  services.gvfs.enable = true;

  # Enable the X11 windowing system.

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
     gscan2pdf
     neofetch
     mariadb
     offlineimap
     openvpn
     vim
     wget
     firefox
     emacs
     alacritty
     git
     samba
     dropbox
     neovim
     gparted
     pandoc
     tint2
     okular
     qutebrowser
     dmenu
     libreoffice-fresh
     mate.engrampa
     vlc
     rofi
     dmenu
     brave
     qbittorrent
     papirus-icon-theme
     lyx
     texlive.combined.scheme-full
     viewnior
     skypeforlinux
     wine
     silver-searcher
     masterpdfeditor
     zip
     unzip
     pdftk
     libertine
     openconnect
     tlp
     powertop
     ripgrep
     gimp
     shutter
     ibus
     ibus-engines.m17n
     brightnessctl
     imagemagick
     wmctrl
     sublime
     networkmanagerapplet
     xfce.xfce4-terminal
     lispPackages.clx
     sbcl
     xorg.xf86videoamdgpu
     pavucontrol
     pa_applet
     flameshot
     lispPackages.xembed
     lispPackages.cl-ppcre
     lispPackages.alexandria
     lispPackages.clx-truetype
     feh
     ispell
     picom
     gnome.gnome-boxes
     xfce.thunar
     aspell
     networkmanager_dmenu
     polybar
     pywal
     calc
     gcc
     nix-index
     pciutils
     usbutils
     libertine
     gnome.cheese
     noto-fonts
     noto-fonts-extra    
     linuxHeaders
     killall
     gnumake
     zoom-us
     gnome.gnome-flashback
     vice
     ghostscript
     jabref
  ];
   
   # Necessary for installing etcher
   nixpkgs.config.permittedInsecurePackages = [
     "electron-12.2.3"
     "openjdk-18+36"
   ];

   environment.etc."dual-function-keys.yaml".text = ''
    TIMING:
      TAP_MILLISEC: 250
      DOUBLE_TAP_MILLISEC: 150

    MAPPINGS:
      - KEY: KEY_TAB
        TAP: KEY_TAB 
        HOLD: KEY_LEFTMETA
      - KEY: KEY_RIGHTALT
        TAP: KEY_TAB
        HOLD: KEY_TAB
 '';

   services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
    '';
  };

# fonts.fonts = with pkgs; [
# noto-fonts
# noto-fonts-cjk
#  noto-fonts-emoji
#  liberation_ttf
#  fira-code
#  fira-code-symbols
#  mplus-outline-fonts
#  dina-font
#  proggyfonts
#  ];

  nixpkgs.config.allowUnfree = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


nixpkgs.overlays = [
  (self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
      configFile = (builtins.readFile /home/michael/.config/dwm/config.h);
    });
  })
];

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

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
  systemd.services.systemd-user-sessions.enable = false; #(after rebuild do rm /run/nologin)
}
