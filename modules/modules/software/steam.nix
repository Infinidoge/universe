{ config, lib, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.software.steam;
  gamescopeCfg = config.programs.gamescope;

  hw = config.modules.hardware;

  steam-gamescope =
    let
      exports = builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env);
    in
    pkgs.writeShellScriptBin "steam-gamescope" ''
      ${builtins.concatStringsSep "\n" exports}
      gamescope --steam ${toString cfg.gamescopeSession.args} -- steam -tenfoot -pipewire-dmabuf
    '';

  gamescopeSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
      [Desktop Entry]
      Name=Steam
      Comment=A digital distribution platform
      Exec=${steam-gamescope}/bin/steam-gamescope
      Type=Application
    '').overrideAttrs (_: { passthru.providedSessions = [ "steam" ]; });
in
{
  options.modules.software.steam = {
    enable = mkEnableOption (lib.mdDoc "steam");

    package = mkOption {
      type = types.package;
      default = pkgs.steam;
      defaultText = literalExpression "pkgs.steam";
      example = literalExpression ''
        pkgs.steam-small.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true;
            RADV_TEX_ANISO = 16;
          };
          extraLibraries = p: with p; [
            atk
          ];
        }
      '';
      apply = steam: steam.override (prev: {
        extraLibraries = pkgs:
          let
            prevLibs = if prev ? extraLibraries then prev.extraLibraries pkgs else [ ];
            additionalLibs = with config.hardware.opengl;
              if pkgs.stdenv.hostPlatform.is64bit
              then [ package ] ++ extraPackages
              else [ package32 ] ++ extraPackages32;
          in
          prevLibs ++ additionalLibs;
      }
      // (optionalAttrs (cfg.gamescopeSession.enable && gamescopeCfg.capSysNice) {
        buildFHSEnv = pkgs.buildFHSEnv.override {
          # use the setuid wrapped bubblewrap
          bubblewrap = "${config.security.wrapperDir}/..";
        };
      })
      // (optionalAttrs hw.gpu.nvidia {
        extraProfile = ''
          unset VK_ICD_FILENAMES
          export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json
        '';
      }));
      description = lib.mdDoc ''
        The Steam package to use. Additional libraries are added from the system
        configuration to ensure graphics work properly.

        Use this option to customise the Steam package rather than adding your
        custom Steam to {option}`environment.systemPackages` yourself.
      '';
    };

    remotePlay.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open ports in the firewall for Steam Remote Play.
      '';
    };

    dedicatedServer.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open ports in the firewall for Source Dedicated Server.
      '';
    };

    gamescopeSession = mkOption {
      description = mdDoc "Run a GameScope driven Steam session from your display-manager";
      default = { };
      type = types.submodule {
        options = {
          enable = mkEnableOption (mdDoc "GameScope Session");
          args = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = mdDoc ''
              Arguments to be passed to GameScope for the session.
            '';
          };

          env = mkOption {
            type = types.attrsOf types.str;
            default = { };
            description = mdDoc ''
              Environmental variables to be passed to GameScope for the session.
            '';
          };
        };
      };
    };
  };

  config = mkMerge [
    {
      assertions = [{
        assertion = if cfg.enable then config.info.graphical else true;
        message = "Steam cannot be enabled in a non-graphical environment";
      }];
    }

    (mkIf cfg.enable {
      # Taken from the programs.steam option, reimplemented here to move software into userland
      hardware.opengl = {
        enable = true;
        driSupport32Bit = true;
      };

      hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

      hardware.steam-hardware.enable = true;

      home.home.packages = [
        cfg.package
        cfg.package.run

        pkgs.protonup
        pkgs.wineWowPackages.stable
      ] ++ lib.optional cfg.gamescopeSession.enable steam-gamescope;

      security.wrappers = mkIf (cfg.gamescopeSession.enable && gamescopeCfg.capSysNice) {
        # needed or steam fails
        bwrap = {
          owner = "root";
          group = "root";
          source = "${pkgs.bubblewrap}/bin/bwrap";
          setuid = true;
        };
      };

      programs.gamescope.enable = mkDefault cfg.gamescopeSession.enable;
      services.xserver.displayManager.sessionPackages = mkIf cfg.gamescopeSession.enable [ gamescopeSessionFile ];
      networking.firewall = lib.mkMerge [
        (mkIf cfg.remotePlay.openFirewall {
          allowedTCPPorts = [ 27036 ];
          allowedUDPPortRanges = [{ from = 27031; to = 27036; }];
        })

        (mkIf cfg.dedicatedServer.openFirewall {
          allowedTCPPorts = [ 27015 ]; # SRCDS Rcon port
          allowedUDPPorts = [ 27015 ]; # Gameplay traffic
        })
      ];
    })
  ];
}
