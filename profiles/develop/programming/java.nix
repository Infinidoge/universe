{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    openjdk17
  ];
}
