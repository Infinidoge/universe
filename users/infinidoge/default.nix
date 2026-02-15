{
  config,
  common,
  secrets,
  lib,
  pkgs,
  ...
}:
{
  home =
    { config, home, ... }:
    {
      imports = with home; [
        bash
        direnv
        fish
        git
        gpg
        htop
        neovim
        nix-index
        ssh
        starship
        tealdeer
        tmux
        vim
        zoxide
        zsh
        dotfiles.neofetch
      ];

      programs.git.settings = {
        user.email = "infinidoge@inx.moe";
        user.name = "Infinidoge";
        gpg.format = "ssh";
        commit.gpgsign = true;
        user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };

      home.sessionVariables = {
        KEYID = "0x30E7A4C03348641E";
      };
    };

  systemd.user.tmpfiles.users.infinidoge.rules = [
    "L+ /home/infinidoge/.local/share/jellyfinmediaplayer/scripts/mpris.so - - - - ${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so"
  ];

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
