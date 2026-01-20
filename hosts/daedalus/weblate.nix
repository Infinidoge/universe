{
  pkgs,
  lib,
  common,
  secrets,
  ...
}:
let
  python = pkgs.python3.override {
    packageOverrides = final: prev: {
      django = prev.django_5;
    };
  };

  domain = common.subdomain "weblate";
in
{
  age.secrets.weblate-secret-key = {
    rekeyFile = ./secrets/weblate-secret-key.age;
    generator.script = { pkgs, ... }: "${pkgs.weblate}/bin/weblate-generate-secret-key";
    owner = "weblate";
    group = "weblate";
  };

  persist.directories = [ "/var/lib/weblate" ];

  services.weblate = {
    enable = true;
    package = pkgs.weblate.overridePythonAttrs (old: {
      dependencies =
        old.dependencies
        # TODO: PR as an optional-dependencies set
        ++ (with python.pkgs; [
          python3-saml
        ]);
    });
    localDomain = domain;
    djangoSecretKeyFile = secrets.weblate-secret-key;

    smtp = with common.email; {
      enable = true;
      user = outgoing;
      from = withSubaddress "weblate";
      host = smtp.address;
      port = smtp.STARTTLS;
      passwordFile = secrets.smtp-noreply;
    };

    extraConfig = ''
      ADMINS += (("Infinidoge", "infinidoge@inx.moe"),)

      AUTHENTICATION_BACKENDS = (
        "social_core.backends.email.EmailAuth",
        "social_core.backends.saml.SAMLAuth",
        "social_core.backends.github.GithubOAuth2",
        "weblate.accounts.auth.WeblateUserBackend",
      )

      with open("/etc/secrets/weblate/saml.crt") as f:
        SOCIAL_AUTH_SAML_SP_PUBLIC_CERT = f.read().rstrip("\n")
      with open("/etc/secrets/weblate/saml.key") as f:
        SOCIAL_AUTH_SAML_SP_PRIVATE_KEY = f.read().rstrip("\n")

      with open("/etc/secrets/weblate/authentik.crt") as f:
        authentik_cert = f.read().rstrip("\n")

      SOCIAL_AUTH_SAML_SP_ENTITY_ID = "https://${domain}/accounts/metadata/saml/"
      SOCIAL_AUTH_SAML_ENABLED_IDPS = {
        "weblate": {
          "entity_id": "https://auth.inx.moe/application/saml/weblate/sso/binding/redirect",
          "url": "https://auth.inx.moe/application/saml/weblate/sso/binding/redirect/",
          "x509cert": authentik_cert,
          "attr_email": "urn:oid:0.9.2342.19200300.100.1.3",
          "attr_username": "urn:oid:0.9.2342.19200300.100.1.1",
          "attr_full_name": "urn:oid:2.5.4.3",
        }
      }
      SOCIAL_AUTH_SAML_ORG_INFO = {
        "en-US": {
          "name": "inxweblate",
          "displayname": "INX Weblate",
          "url": "https://weblate.inx.moe",
        }
      }
      SOCIAL_AUTH_SAML_TECHNICAL_CONTACT = {
        "givenName": "Lillith",
        "emailAddress": "admin@inx.moe",
      }
      SOCIAL_AUTH_SAML_SUPPORT_CONTACT = {
        "givenName": "Evil Lillith",
        "emailAddress": "admin@inx.moe",
      }

      SOCIAL_AUTH_GITHUB_KEY = "Ov23liH7GWzgesskSZnM"
      SOCIAL_AUTH_GITHUB_SCOPE = ["user:email"]
      with open("/etc/secrets/weblate/github.key") as f:
        SOCIAL_AUTH_GITHUB_SECRET = f.read().rstrip("\n")
    '';
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    enableACME = lib.mkForce false; # Covered by ssl-inx
  };

  users.users.weblate.extraGroups = [ "smtp" ];
}
