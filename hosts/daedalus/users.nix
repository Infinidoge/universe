{ pkgs, private, ... }:

{
  imports = [ private.nixosModules.private-users ];

  users.users.mistergij = {
    description = "Account for hosting DnD World bots";
    isNormalUser = true;
    shell = pkgs.bash;
  };

  users.users.alina = {
    description = "Alina, Cutest woofer";
    isNormalUser = true;
    shell = pkgs.nushell;
  };

  users.users.solonovamax = {
    description = "Solo, Does programming sometimes";
    isNormalUser = true;
    shell = pkgs.bash;
  };

  services.openssh.extraConfig = ''
    Match user mistergij
      DisableForwarding yes

    Match user solonovamax
      DisableForwarding yes
  '';
}
