;; This is an operating system configuration template
;; for a "desktop" setup without full-blown desktop
;; environments.

(use-modules (gnu) (gnu system nss))
(use-service-modules desktop)
(use-package-modules bootloaders certs emacs emacs-xyz ratpoison suckless wm
                     xorg)

(operating-system
  (host-name "guixyana")
  (timezone "Europe/Vienna")
  (locale "en_GB.utf8")

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")))

  ;; Assume the target root file system is labelled "my-root",
  ;; and the EFI System Partition has UUID 1234-ABCD.
  (file-systems (append
                 (list ((file-system
			 (mount-point "/")
			 (device "/dev/sda3")
			 (type "ext4"))
			(file-system
                         (device "/dev/sda1")
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (users (cons (user-account
                (name "michael")
                (comment "Main user")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  ;; Add a bunch of window managers; we can choose one at
  ;; the log-in screen with F1.
  (packages (append (list
                     ;; window managers
                     stumpwm dmenu
                     emacs emacs-exwm emacs-desktop-environment
                     ;; terminal emulator
                     xterm
		     terminator
                     ;; for HTTPS access
                     nss-certs)
                    %base-packages))

  ;; Use the "desktop" services, which include the X11
  ;; log-in service, networking with NetworkManager, and more.
  (services %desktop-services)

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
