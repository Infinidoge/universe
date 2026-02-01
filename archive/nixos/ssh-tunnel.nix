{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.ssh-tunnel;
in
{
  options.services.ssh-tunnel = {
    enable = mkEnableOption "SSH tunneling service";

    server = mkOption {
      type = with types; uniq str;
      default = null;
      description = "The SSH server to connect for port forwarding";
    };

    requiredBy = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "List of systemd services that require the SSH tunnels";
    };

    forwards = mkOption {
      type = types.submodule {
        options = {
          dynamic = mkOption {
            type = with types; listOf (either port str);
            default = [ ];
            description = "List of dynamic ports to open through the ssh tunnel. See ssh(1) for ``-D``";
          };
          local = mkOption {
            type = with types; listOf (either port str);
            default = [ ];
            description = "List of local ports to open through the ssh tunnel. See ssh(1) for ``-L``";
          };
          remote = mkOption {
            type = with types; listOf (either port str);
            default = [ ];
            description = "List of remote ports to open through the ssh tunnel. See ssh(1) for ``-R``";
          };
        };
      };
    };
  };

  config.systemd.services.ssh-tunnel = mkIf cfg.enable (
    let
      mkParams = flag: concatMapStringsSep " " (x: "${flag} ${toString x}");

      dynamic = mkParams "-D" cfg.forwards.dynamic;
      local = mkParams "-L" cfg.forwards.local;
      remote = mkParams "-R" cfg.forwards.remote;

      options = mkParams "-o" (
        mapAttrsToList (n: v: "${n}=${toString v}") {
          ServerAliveInterval = 60;
          ExitOnForwardFailure = "yes";
          KbdInteractiveAuthentication = "no";
        }
      );
    in
    {
      script = ''
        ${pkgs.openssh}/bin/ssh ${cfg.server} -NTn ${options} ${dynamic} ${local} ${remote}
      '';
      requiredBy = cfg.requiredBy;
      serviceConfig = {
        RestartSec = 5;
        Restart = "always";
      };
    }
  );
}
