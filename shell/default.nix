{ self, lib, ... }:

{
  perSystem = { pkgs, ... }: {
    devshells.default =
      let
        pythonEnv = (pkgs.python310.withPackages (p: with p; [
          pkgs.qtile.passthru.unwrapped
        ]));
      in
      {
        devshell.name = "universe";
        devshell.motd = "";

        devshell.packages = [
          pythonEnv
        ];

        env = [
          { name = "PYTHONPATH"; value = "${pythonEnv}/${pythonEnv.sitePackages}"; }
        ];
      };
  };
}
