{ config, pkgs, lib, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./powernix.nix
    ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = "options bluetooth disable_ertm=1";

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

  xdg.portal.enable = true;
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

  services.mullvad-vpn.enable = true;

  # Optional GUI app
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Important for Mullvad routing
  networking.iproute2.enable = true;

  # Mullvad currently works best with resolved enabled
  services.resolved.enable = true;

   users.users.michael = {
     isNormalUser = true;
     password = "test";
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };


   environment.systemPackages = with pkgs; [
     chromium
     libtool
     mpv
     ffmpeg
     cmake
     opencode
     lite-xl
     xorg.xmodmap
     hunspell
     pkgs.hunspellDicts.en-gb-ise
     arandr
     qbittorrent
     gnome-keyring
     fastfetch
     mariadb
     offlineimap
     pkgs.gnome-tweaks
     openvpn
     libertine
     vim
     wget
     firefox
     emacs
     alacritty
     git
     samba
     #dropbox
     dropbox-cli
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
     fira-code
     nerd-fonts.fira-code
     typst
     bibata-cursors
     xdotool
     qemacs
     whitesur-gtk-theme
     whitesur-icon-theme
     mate.mate-tweak
     mate.mate-menus
     flameshot
     krita
     ocrmypdf
     poppler
     poppler-utils
     protonvpn-gui
     qutebrowser
     fd
     gnome-browser-connector
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

fonts.packages = with pkgs; [ 
  noto-fonts
  fira-code
  libertine
  nerd-fonts.fira-code
];

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

i18n.inputMethod = {
  enabled = "ibus";
  ibus.engines = with pkgs.ibus-engines; [ m17n ];
};

  system.stateVersion = "21.05";
 #(after rebuild do rm /run/nologin)
  systemd.services.systemd-user-sessions.enable = false;
}
