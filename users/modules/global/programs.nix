{
  config,
  main,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) flip;
  inherit (lib.our) mkBoolOpt' packageListOpt;

  packagesOpt = kind: flip mkBoolOpt' "Package Set: ${kind}";

  full = !main.universe.minimal.enable;

  cfg = config.universe.programs;

  ifGraphical = lib.optionals main.info.graphical;
  ifGraphical' = lib.optional main.info.graphical;

  addPackageLists = lib.mapAttrs (
    name: value:
    value
    // {
      minimal = packageListOpt;
      full = packageListOpt;
    }
  );
in

{
  options.universe.programs = (
    addPackageLists {
      utility.enable = packagesOpt "Utility" true;
      writing.enable = packagesOpt "Writing" true;
      communication.enable = packagesOpt "Communication" true;
      internet.enable = packagesOpt "Internet" true;
    }
  );

  config = {
    universe.programs = with pkgs; {
      utility.minimal = [
        bitwarden-cli
        bsd-finger
        ncdu
        peaclock
        pop
        qrencode
        reflex
        unison
        (ifGraphical [
          speedcrunch
        ])
      ];
      utility.full = [
        jmtpfs
        packwiz
        presenterm
        toot
        (ifGraphical [
          bitwarden-desktop
          qbittorrent
          sqlitebrowser
        ])
      ];

      writing.full = [
        gramma
      ];

      communication.minimal = [
        (ifGraphical [
          (discord-canary.override {
            inherit (pkgs) vencord;
            withVencord = true;
            withOpenASAR = true;
            withTTS = false;
          })
          thunderbird
        ])
      ];
      communication.full = [
        (ifGraphical [
          (discord.override {
            withVencord = true;
            withOpenASAR = true;
            withTTS = false;
          })
          mumble
          schildichat-desktop
          signal-desktop
          teams-for-linux
        ])
      ];

      internet.full = [
        (ifGraphical [
          tor-browser
        ])
      ];
    };

    home.packages = lib.concatMap (
      v:
      (lib.optionals (v ? minimal && v.enable) v.minimal)
      ++ (lib.optionals (v ? full && full && v.enable) v.full)
    ) (lib.attrValues cfg);

  };
}
