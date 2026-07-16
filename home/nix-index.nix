{ inputs, ... }:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
}
