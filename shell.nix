{ self, lib, ... }:

{
  perSystem =
    {
      config,
      pkgs,
      inputs',
      ...
    }:
    {
      devshells.default =
        let
          pythonEnv = (
            pkgs.python3.withPackages (
              p: with p; [
                qtile
                qtile-extras
              ]
            )
          );
        in
        {
          devshell.name = "universe";
          devshell.motd = "";

          devshell.packages = with pkgs; [
            pythonEnv
            inputs'.disko.packages.disko
            config.agenix-rekey.package
            age-plugin-fido2-hmac
            age-plugin-yubikey
          ];

          env = [
            {
              name = "PYTHONPATH";
              prefix = "${pythonEnv}/${pythonEnv.sitePackages}";
            }
          ];
        };
    };
}
