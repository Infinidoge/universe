{ self, lib, ... }:

{
  perSystem = { pkgs, inputs', ... }: {
    devshells.default =
      let
        pythonEnv = (pkgs.python3.withPackages (p: with p; [
          qtile
        ]));
      in
      {
        devshell.name = "universe";
        devshell.motd = "";

        devshell.packages = [
          pythonEnv
          inputs'.disko.packages.disko
        ];

        env = [
          { name = "PYTHONPATH"; value = "${pythonEnv}/${pythonEnv.sitePackages}"; }
        ];
      };
  };
}
