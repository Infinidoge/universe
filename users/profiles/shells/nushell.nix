{ ... }: {
  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ~/.cache/starship/init.nu
    '';
    envFile.text = ''
      mkdir ~/.cache/starship
      starship init nu | save ~/.cache/starship/init.nu
    '';
  };
}
