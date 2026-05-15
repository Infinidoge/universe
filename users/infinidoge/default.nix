{
  pkgs,
  ...
}:
{
  home = {
    imports = [ ./home.nix ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.symbols-only
    dejavu_fonts
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "DejaVuSansMono" ];
  };

  user = {
    name = "infinidoge";
    uid = 1000;
    description = "Infinidoge, primary user of the system";
    group = "users";
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "bluetooth"
      "borg"
      "copyparty"
      "dialout"
      "disk"
      "docker"
      "factorio"
      "forgejo"
      "garage"
      "incoming"
      "jellyfin"
      "libvirtd"
      "minecraft"
      "named"
      "nginx"
      "pipewire"
      "plugdev"
      "smtp"
      "systemd-journal"
      "video"
      "wheel"
      "wpa_supplicant"
      "wwwrun"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };
}
