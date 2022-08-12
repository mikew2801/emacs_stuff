#https://nixos.wiki/wiki/AMD_GPU

{config, pkgs, ...}:

{
networking.hostName = "nixbox";

# Boot the amdgpu module early
boot.initrd.kernelModules = [ "amdgpu" ];

# This is for the network card
boot.extraModulePackages = with config.boot.kernelPackages; [rtw89];

services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager.gdm.enable = true;

    windowManager.stumpwm.enable = true;

    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;

    desktopManager.cinnamon.enable = true;

    windowManager.exwm = {
      enable = true;
      enableDefaultConfig = false;
      loadScript = "";
      extraPackages = epkgs: [
        epkgs.emacsql-sqlite
    ];
    };

    windowManager.openbox.enable = true;
};
}
