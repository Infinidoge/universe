{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (discord-canary.override {
      inherit (pkgs) vencord;
      withVencord = true;
      withTTS = false;
    })
    thunderbird

    (discord.override {
      withVencord = true;
      withTTS = false;
    })
    mumble
    signal-desktop
    teams-for-linux
  ];
}
