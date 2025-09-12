{ pkgs, ... }:

{
  users.users.mistergij = {
    description = "Account for hosting DnD World bots";
    isNormalUser = true;
    shell = pkgs.bash;
  };

  users.users.alina = {
    description = "Cutest woofer";
    isNormalUser = true;
    shell = pkgs.nushell;
  };

  services.openssh.extraConfig = ''
    Match user mistergij
      DisableForwarding yes
  '';
}
