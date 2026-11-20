{ ... }:
{
  programs.nushell = {
    enable = true;
    loadSessionVariables = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
      }
    '';
  };
}
