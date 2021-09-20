{ pkgs, ... }: {
  imports = [ ./steam.nix ];

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
  ];

  home.packages = with pkgs; [
    multimc
    lutris
  ];
}
