{
  pkgs,
  ...
}:
{
  home =
    { config, home, ... }:
    let
      # alias to re-execute Git with the correct name/email
      headmate = name: email: ''!git -c user.name="${name}" -c user.email="${email}"'';
    in
    {
      programs.git.signing.format = "ssh";
      programs.git.settings = {
        user.email = "infinidoge@inx.moe";
        user.name = "Infinidoge";
        gpg.format = "ssh";
        commit.gpgsign = true;
        user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";

        alias = {
          evil = headmate "Evil Lillith" "evil-lillith@inx.moe";
          dark = headmate "Dark Lillith" "dark-lillith@inx.moe";
        };
      };

      home.sessionVariables = {
        KEYID = "0x30E7A4C03348641E";
      };
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
      "wwwrun"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };
}
