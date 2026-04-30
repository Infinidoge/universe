{ pkgs, ... }:
let
  # BUG: openssl 1.1.1w is insecure
  #      Override it to mark it as secure for just Discord
  openssl_1_1 = pkgs.openssl_1_1.overrideAttrs (old: {
    meta = old.meta // {
      knownVulnerabilities = [ ];
    };
  });
in
{
  home.packages = with pkgs; [
    (discord-canary.override {
      inherit (pkgs) vencord;
      inherit openssl_1_1;
      withVencord = true;
      withOpenASAR = true;
      withTTS = false;
    })
    thunderbird

    (discord.override {
      inherit openssl_1_1;
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
