{ lib, private, ... }:
let
  inherit (lib.hm) dag;
  clusters = [
    "anvil"
    "bell"
    "gautschi"
    "gilbreth"
    "negishi"
    "rowdy"
    "scholar"
  ];

  mkNode' =
    name: hostname: jump: data:
    dag.entryAfter [ jump ] (
      {
        header = "Host ${name}";
        User = private.variables.purdue-username;
        Hostname = hostname;
        ProxyJump = jump;
      }
      // data
    );
  mkNode =
    name: hostname: jump:
    mkNode' name hostname jump { };

  mkLogin = name: mkNode name "${name}.rcac.purdue.edu" "argus";
  mkProxy =
    name:
    mkNode' "mgmt.${name}-proxy" "mgmt.${name}.rcac.purdue.edu" "${name}" {
      DynamicForward = "127.0.0.1:49494";
    };

  mkCluster = name: {
    "${name}" = mkLogin name;
    "${name}-internal" = mkNode "*.${name}" "%h.rcac.purdue.edu" name;
    "${name}-mgmt-proxy" = mkProxy name;
  };

in
{
  programs.ssh.settings = lib.mkMerge (
    [
      {
        argus = {
          header = "Host argus";
          Hostname = "argus.tailnet.inx.moe";
        };
        mgmt = mkLogin "mgmt";
        mgmt-proxy = mkNode' "mgmt-proxy" "mgmt" "argus" {
          DynamicForward = "127.0.0.1:49494";
        };
      }
    ]
    ++ map mkCluster clusters
  );
}
