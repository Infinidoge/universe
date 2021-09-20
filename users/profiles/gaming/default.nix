{ pkgs, ... }: {
  imports = [ ./steam.nix ];

  home.packages = with pkgs; [
    wineWowPackages.stable
    (multimc.override { msaClientID = "01524508-0110-46fc-b468-362d31ca41e6"; })
    lutris
  ];
}
