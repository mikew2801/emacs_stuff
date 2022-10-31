

;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu) (nongnu packages linux))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/Vienna")
  (keyboard-layout (keyboard-layout "gb" #:options '("ctrl:swapcaps")))
  (host-name "guix-yana")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "michael")
                  (comment "Michael Williams")
                  (group "users")
                  (home-directory "/home/michael")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages (append (list (specification->package "i3-wm")
                          (specification->package "i3status")
                          (specification->package "dmenu")
                          (specification->package "st")
                          (specification->package "emacs")
                          (specification->package "pandoc")
                          (specification->package "gcc-toolchain")
                          (specification->package "flatpak")
                          (specification->package "brightnessctl")
                          (specification->package "nix")
                          (specification->package "okular")
                          (specification->package "libreoffice")
			  (specification->package "qutebrowser")
			  (specification->package "neovim")
			  (specification->package "font-linuxlibertine")
			  (specification->package "vlc")
			  (specification->package "groff")
			  (specification->package "alacritty")
			  (specification->package "zip")
			  (specification->package "papirus-icon-theme")
			  (specification->package "unzip")
			  (specification->package "feh")
			  (specification->package "polybar")
			  (specification->package "surf")
			  (specification->package "nyxt")
			  (specification->package "gnome-tweaks")
			  (specification->package "texlive-libertine")
			  (specification->package "texlive")
			  (specification->package "vim")
			  (specification->package "terminator")
			  (specification->package "emacs-exwm")
			  (specification->package "gcc")
			  (specification->package "emacs-emacsql")
			  (specification->package "picom")
			  (specification->package "rofi")
			  (specification->package "sbcl")
			  (specification->package "stumpwm")
			  (specification->package "xdg-desktop-portal")
			  (specification->package "xdg-desktop-portal-gtk")
                          (specification->package
                           "emacs-desktop-environment")
                          (specification->package "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service gnome-desktop-service-type)
		 (service mate-desktop-service-type)
                 (service cups-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "a74ca59c-18ad-49c7-931f-443cad690f8b")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "A959-18F4"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "07f42c90-3839-4c92-ac3e-3b22202b7335"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
