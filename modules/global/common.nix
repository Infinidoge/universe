{ config, ... }:
{
  _module.args.common = config.common;

  common = rec {
    domain = "inx.moe";
    subdomain = subdomain: "${subdomain}.${domain}";

    nginx = rec {
      ssl-cert = {
        enableACME = true;
        acmeRoot = null;
      };
      ssl-optional = ssl-cert // {
        addSSL = true;
      };
      ssl = ssl-cert // {
        forceSSL = true;
      };
    };

    rsyncnet = rec {
      account = "de3482";
      user = "${account}s1";
      host = "${account}.rsync.net";
    };

    email = rec {
      withUser = user: "${user}@${domain}";
      outgoingUser = "noreply";
      incomingUser = "incoming";
      outgoing = withUser outgoingUser;
      incoming = withUser incomingUser;
      withSubaddress = subaddress: "${outgoingUser}+${subaddress}@${domain}";

      smtp = {
        address = "smtp.purelymail.com";
        SSLTLS = 465;
        STARTTLS = 587;
      };
      imap = {
        address = "imap.purelymail.com";
        port = 993;
      };
    };
  };
}
