{
  self,
  lib,
  common,
  secrets,
  ...
}:
let
  inherit (lib.our.secrets) withOwner withGroup;
in
{
  common.email = rec {
    withUser = user: "${user}@${common.domain}";
    outgoingUser = "noreply";
    incomingUser = "incoming";
    outgoing = withUser outgoingUser;
    incoming = withUser incomingUser;
    withSubaddress = subaddress: "${outgoingUser}+${subaddress}@${common.domain}";

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

  programs.msmtp = with common.email; {
    enable = true;
    setSendmail = true;
    defaults = {
      host = smtp.address;
      port = smtp.STARTTLS;
      tls = true;
      auth = true;
    };
    accounts = rec {
      noreply = {
        user = outgoing;
        passwordeval = "cat ${secrets.smtp-noreply}";
      };
      default = noreply // {
        from = withSubaddress "%U-%H";
      };
    };
  };

  users.groups.smtp = { };

  age.secrets.smtp-noreply = withGroup "smtp" "${self}/secrets/smtp-noreply.age";
  age.secrets.smtp-personal = withOwner "infinidoge" "${self}/secrets/smtp-personal.age";

  home.home.sessionVariables = {
    POP_SMTP_HOST = common.email.smtp.address;
    POP_SMTP_PORT = common.email.smtp.STARTTLS;
    POP_SMTP_USERNAME = common.email.withUser "infinidoge";
    POP_SMTP_PASSWORD = "$(cat ${secrets.smtp-personal})";
  };
}
