{ config, pkgs, ... }: {
  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom;
  # };

  # services.emacs = {
  #   enable = true;
  #   package = config.programs.emacs.package;
  # };

  environment.systemPackages = with pkgs; [
    emacs
    ripgrep
    coreutils
    cmake
    fd
    fzf
    clang
    mu
    isync
    tetex
    jq
    gnumake
    shellcheck
    nodejs
    nodePackages.prettier

    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
  ];
}
