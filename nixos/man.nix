{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix

    tealdeer
  ];

  # Disable man cache
  # I don't use it, and it takes ages on rebuild
  documentation.man.generateCaches = lib.mkForce false;
  home-manager.sharedModules = [
    { programs.man.generateCaches = lib.mkForce false; }
  ];
}
