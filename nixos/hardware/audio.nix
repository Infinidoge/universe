{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  security.rtkit.enable = false; # FIXME: https://github.com/NixOS/nixpkgs/issues/392992

  environment.systemPackages = with pkgs; [
    easyeffects
  ];

  persist.directories = [
    "/var/lib/alsa"
  ];
}
