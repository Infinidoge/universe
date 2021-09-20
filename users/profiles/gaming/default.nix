{ pkgs, ... }: {
  imports = [ ./steam.nix ];

  home.packages = with pkgs; [
    multimc
    lutris
  ];
}
