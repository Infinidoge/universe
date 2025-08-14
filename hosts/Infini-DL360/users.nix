{ pkgs, ... }:

{
  users.users.mistergij = {
    description = "Account for hosting DnD World bots";
    isNormalUser = true;
    shell = pkgs.bash;
  };

  services.openssh.extraConfig = ''
    Match user mistergij
      DisableForwarding yes
  '';
}
