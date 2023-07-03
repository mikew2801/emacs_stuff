{config, pkgs, ...}:

{
networking.hostName = "powernix";


services.xserver = {
    enable = true;
    #videoDrivers = lib.mkIf (config.networking.hostName == "nixbox") [ "amdgpu" ];
    #displayManager.gdm.enable = lib.mkIf (config.networking.hostName == "nixbox") true;
    #displayManager.lightdm.enable = lib.mkIf (config.networking.hostName == "workbox") true;
    windowManager.stumpwm.enable = true;

    #windowManager.xmonad.enable = true;
    #windowManager.xmonad.enableContribAndExtras = true;

    #windowManager.i3.enable = true;
    #windowManager.i3.package = pkgs.i3-gaps;

    desktopManager.cinnamon.enable = true;
    
    windowManager.exwm = {
      enable = true;
      enableDefaultConfig = false;
      loadScript = "";
      extraPackages = epkgs: [
        epkgs.emacsql-sqlite
    ];
    };
    #windowManager.openbox = { enable = true;};
};
}
