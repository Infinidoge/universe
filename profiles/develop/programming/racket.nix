{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    racket
  ];
}
