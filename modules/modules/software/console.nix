{ config, options, lib, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.software.console;
  opt = options.modules.software.console;
in
{
  options.modules.software.console = with types; {
    kmscon = {
      enable = mkBoolOpt true;
      font = {
        size = mkOpt int 14;
        font = mkOpt str (head config.modules.locale.fonts.defaults.monospace);
      };
      extraOptions = mkOpt (separatedString " ") "";
      extraConfig = mkOpt lines "";
    };
  };

  config = {
    console = {
      font = "Lat2-Terminus16";
      earlySetup = true;
    };

    services.kmscon = mkIf cfg.kmscon.enable {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-size=${toString cfg.kmscon.font.size}
        font-name=${cfg.kmscon.font.font}
        ${cfg.kmscon.extraConfig}
      '';
      extraOptions = mkAliasDefinitions opt.kmscon.extraOptions;
    };
  };
}
