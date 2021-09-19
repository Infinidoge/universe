{ pkgs, config, ... }: {
  programs.password-store = {
    enable = true;
    package = pkgs.pass;
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
      PASSWORD_STORE_KEY = "2C0BB53DFA3BB79F64B0ADCAAA0E1F926FAF03C0"; # Named "Infinidoge (Master Password)"
      PASSWORD_STORE_GENERATED_LENGTH = "20";
      PASSWORD_STORE_CLIP_TIME = "60";
    };
  };

  home.file."${config.xdg.configHome}/pass-git-helper/git-pass-mapping.ini".text = ''
    [gitlab.com*]
    target=dev/gitlab.com/infinidoge_api
  '';

  services.password-store-sync.enable = true;

  environment.systemPackages = with pkgs; [ pinentry-curses ];
}
