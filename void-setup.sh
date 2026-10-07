# 7 Oct 2026

xbps-install -u xbps
xbps-install -Suv
xbps-install void-repo-nonfree neovim engrampa zip unzip emacs-gtk3 xmodmap git
xbps-install -Suv
xbps-install dropbox
dropbox start -i

# Now enable xmodmap
cat << EOF > ~/modmap
       !
       ! Swap Caps_Lock and Control_L
       !
       remove Lock = Caps_Lock
       remove Control = Control_L
       keysym Control_L = Caps_Lock
       keysym Caps_Lock = Control_L
       add Lock = Caps_Lock
       add Control = Control_L
EOF

echo "Content has been written to ~/modmap."

sudo xbps-install alacritty arandr aspell-en autoconf automake autorandr bison blueman dmenu fakeroot feh flex gcc gedit gimp git gpart gparted ibus ibus-m17n libreoffice lxappearance lxinput m4 make mariadb network-manager-applet NetworkManager ntfs-3g okular p7zip pandoc patch pavucontrol pkgconf pdftk qbittorrent ripgrep rofi rsync rtorrent sudo texinfo Thunar thunar-volman timeshift unrar usbutils viewnior vim vlc wireless_tools wpa_supplicant polybar gvfs wmctrl git mu offlineimap curl xinput picom xrdb nerd-fonts dejavu-fonts-ttf engrampa font-misc-misc gnome-themes-standard lightdm lightdm-gtk-greeter linux-tools mu4e neovim picom poppler-devel poppler-glib-devel setxkbmap terminus-font tlp udisks2 unzip void-docs-browse void-live-audio void-repo-nonfree xauth zip zlib-devel youtube-dl qemacs hunspell hunspell-en_GB-ize papirus-icon-theme poppler linux-firmware acpi brightnessctl cheese fastfetch xsetroot libX11-devel libXinerama-devel libXft-devel libspa-bluetooth gnome keyd wireguard-tools wireguard-dkms zstd xtools scrot ghostscript audacity

