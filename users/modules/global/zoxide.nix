{ ... }:
{
  programs.zoxide = {
    enable = true;

    options = [
      "--cmd cd"
      "--hook pwd"
    ];

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
