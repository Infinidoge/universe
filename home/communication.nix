{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (discord-canary.override {
      inherit (pkgs) vencord;
      withVencord = true;
      withOpenASAR = true;
      withTTS = false;
    })
    thunderbird

    (discord.override {
      withVencord = true;
      withOpenASAR = true;
      withTTS = false;
    })
    mumble
    schildichat-desktop
    signal-desktop
    teams-for-linux
  ];
}
