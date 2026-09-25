{config, pkgs, ...}:

{
networking.hostName = "mininix";

services.xserver = {
    enable = true;
    #videoDrivers = lib.mkIf (config.networking.hostName == "nixbox") [ "amdgpu" ];
    #displayManager.gdm.enable = lib.mkIf (config.networking.hostName == "nixbox") true;
    #displayManager.lightdm.enable = lib.mkIf (config.networking.hostName == "workbox") true;

    displayManager.gdm.enable = true;

    windowManager.stumpwm.enable = true;
    windowManager.exwm.enable = true;
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        src = /home/michael/Dropbox/dwm-6.7;
      });
    };

    desktopManager.gnome.enable = true;
    #desktopManager.mate.enable = true;

    # Only one of cinnamon/gnome can be enabled without conflict
    #desktopManager.cinnamon.enable = true;
    #desktopManager.xfce.enable = true;
    #windowManager.dwm.enable = true;
    #windowManager.qtile.enable = true;
    #windowManager.i3.enable = true;
    #windowManager.xmonad.enable = true;
    #windowManager.xmonad.enableContribAndExtras = true;
    #windowManager.i3.enable = true; 
    #windowManager.i3.package = pkgs.i3-gaps;
    #desktopManager.plasma6.enable = true;
};
}
