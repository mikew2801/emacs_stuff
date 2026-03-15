{ config, pkgs, lib, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./powernix.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = config.hardware.graphics.enable;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_GB.UTF-8";

   console = {
     font = "Lat2-Terminus16";
     keyMap = "uk";
  };

  #services.tlp.enable = true;
  services.blueman.enable = true;
  services.flatpak.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Make sure flathub repository is added for all users
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.gvfs.enable = true;

  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "ctrl:swapcaps";

  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

   users.users.michael = {
     isNormalUser = true;
     password = "test";
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };

   environment.systemPackages = with pkgs; [
     lite-xl
     xorg.xmodmap
     hypnotix
     #discord
     hunspell
     pkgs.hunspellDicts.en-gb-ise
     arandr
     qbittorrent
     gnome-keyring
     neofetch
     mariadb
     offlineimap
     openvpn
     libertine
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
     kdePackages.okular
     dmenu
     libreoffice-fresh
     mate.engrampa
     vlc
     rofi
     dmenu
     brave
     papirus-icon-theme
     lyx
     texlive.combined.scheme-full
     viewnior
     wine
     silver-searcher
     masterpdfeditor4
     zip
     unzip
     pdftk
     libertine
     openconnect
     #tlp
     powertop
     ripgrep
     gimp
     shutter
     ibus
     ibus-engines.m17n
     brightnessctl
     imagemagick
     wmctrl
     networkmanagerapplet
     sbcl
     xorg.xf86videoamdgpu
     pavucontrol
     pa_applet
     acpi
     feh
     ispell
     picom
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
     cheese
     noto-fonts
     linuxHeaders
     killall
     gnumake
     zoom-us
     ghostscript
     maiko
     emacsPackages.exwm
     rclone
     lxappearance
     home-manager
     flatpak
     sqlite
     internetarchive
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

i18n.inputMethod = {
  enabled = "ibus";
  ibus.engines = with pkgs.ibus-engines; [ m17n ];
};


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
