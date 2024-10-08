{ config, pkgs, ... }:
let
  mkPythonKernel = displayName: env: {
    inherit displayName;
    language = "python";
    argv = [ "${env.interpreter}" "-m" "ipykernel_launcher" "-f" "{connection_file}" ];
    logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
    logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
  };
in
{
  services.jupyter = {
    enable = true;
    package = pkgs.python3Packages.jupyterlab;

    # Hosted behind Tailscale, so security doesn't matter
    command = "jupyter-lab --ServerApp.token='' --ServerApp.password=''";
    password = "''";
    ip = "*";

    user = "infinidoge";
    group = "users";
    notebookDir = "~/Notebooks";

    kernels = {
      python3 = mkPythonKernel "Python 3" (pkgs.python3.withPackages (p: with p; [
        ipykernel
        nbconvert
        nbformat

        matplotlib
        numpy
        pandas
        scipy
      ]));
    };
  };

  systemd.services.jupyter.path = with pkgs; [
    pandoc
    (texlive.combine {
      inherit (texlive)
        scheme-medium

        adjustbox
        enumitem
        environ
        pdfcol
        tcolorbox
        titling
        upquote
        ;
    })
  ];

  services.nginx.virtualHosts."jupyter.internal.inx.moe" = config.common.nginx.ssl // {
    listenAddresses = [ "100.101.102.124" ];
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.jupyter.port}";
      proxyWebsockets = true;
    };
  };
}
