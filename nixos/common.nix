{ lib, config, ... }:
{
  imports = [
    { options.common = with lib.types; lib.our.mkOpt (attrsOf anything) { }; }
  ];

  _module.args.common = config.common;

  common = rec {
    domain = "inx.moe";
    subdomain = subdomain: "${subdomain}.${domain}";
  };
}
