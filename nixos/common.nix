{ lib, config, ... }:
{
  imports = [
    { options.common = with lib.types; lib.our.mkOpt (attrsOf anything) { }; }
  ];

  _module.args.common = config.common;

  common = rec {
    domain = "inx.moe";
    subdomain = subdomain: "${subdomain}.${domain}";
    internal = subdomain: "${subdomain}.internal.${domain}";
    staging = subdomain: "${subdomain}.staging.${domain}";
  };
}
