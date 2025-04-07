{ pkgs, ... }:

{
  users.users.cs252 = {
    description = "Guest account for CS 252 researchers";
    group = "users";
    isNormalUser = true;
    shell = pkgs.bash;
  };

  services.openssh.extraConfig = ''
    Match user cs252
      AuthorizedKeysFile /etc/ssh/authorized_keys.d/infinidoge /etc/ssh/authorized_keys.d/%u
      DisableForwarding yes
      PasswordAuthentication no
  '';

  security.pam.loginLimits = [
    {
      domain = "cs252";
      item = "memlock";
      type = "-";
      value = "256000000";
    }
    {
      domain = "cs252";
      item = "as";
      type = "-";
      value = "256000000";
    }
  ];
}
