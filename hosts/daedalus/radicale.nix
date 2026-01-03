{ common, secrets, ... }:

let
  domain = common.subdomain "calendar";
in
{
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [
          "0.0.0.0:5232"
        ];
      };
      auth = {
        type = "ldap";
        ldap_uri = "ldap://ldap.inx.moe:389";
        ldap_base = "dc=ldap,dc=inx,dc=moe";
        ldap_reader_dn = "cn=radicale,ou=users,DC=ldap,DC=inx,DC=moe";
        ldap_secret_file = secrets.radicale-ldap;
        ldap_filter = "(&(objectClass=user)(cn={0}))";
        lc_username = true;
      };
      storage.filesystem_folder = "/srv/radicale";
      rights.type = "owner_only";
      logging.level = "debug";
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/".proxyPass = "http://localhost:5232";
  };
}
