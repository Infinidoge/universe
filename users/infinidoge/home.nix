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
}
