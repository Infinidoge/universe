{ lib, ... }:

let
  scaleFactor = 1.25;

  scaleFactor' = 1 / scaleFactor;
in
{
  environment.variables = {
    GDK_DPI_SCALE = toString scaleFactor;
    QT_SCALE_FACTOR = toString scaleFactor;
  };

  services.autorandr.profiles =
    let
      scale = {
        x = scaleFactor';
        y = scaleFactor';
      };
      config = {
        framework = {
          mode = "2256x1504";
          primary = true;
          inherit scale;
        };
        portable-second = {
          mode = "1920x1080";
          rotate = "left";
        };
        dock = {
          mode = "1280x1024";
          rotate = "left";
        };
        dorm = {
          mode = "1920x1080";
        };
      };
      fingerprints = {
        framework = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
        portable-second = "00ffffffffffff0006b34116818202002b200104a52213783a28659759548e271e5054a10800b30095008180814081c0010101010101023a801871382d40582c450058c21000001e000000ff004e414c4d54463136343438310a000000fd00324b185311000a202020202020000000fc0041535553204d42313641430a20011802030a3165030c0010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c";
        dock = "00ffffffffffff004f2e0030010101012b170104a50000782aa2d0ac5130b425105054a54b00d1c00101818001010101010101010101641900404100263018883600122221000019000000fd003b471e6d10010a202020202020000000fc004e6f6e2d506e500a2020202020000000fe000a20202020202020202020202000fc";
        dorm = "00ffffffffffff0010ac27f1493431442a1f010380301b78eab675a655529f270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c4500dc0c1100001e000000ff00484b50474c4a330a2020202020000000fc0044454c4c204532323231484e0a000000fd00384c1e5311000a2020202020200105020317b14c901f0102030712160413140565030c001000023a801871382d40582c4500dc0c1100001e011d8018711c1620582c2500dc0c1100009e011d007251d01e206e285500dc0c1100001e8c0ad08a20e02d10103e9600dc0c110000180000000000000000000000000000000000000000000000000000000000000000b9";
      };
      config' = lib.mapAttrs (n: v: v // { fingerprint = fingerprints.${n}; }) config;
      mkConfig = config: {
        fingerprint = lib.mapAttrs (_: v: v.fingerprint) config;
        config = lib.mapAttrs (_: v: lib.removeAttrs v [ "fingerprint" ]) config;
      };
    in
    lib.mapAttrs (_: mkConfig) (
      with config';
      {
        main = {
          eDP-1 = framework // {
            position = "0x0";
          };
        };
        portable-second = {
          eDP-1 = framework // {
            position = "1080x716";
          };
          DP-4 = portable-second // {
            position = "0x0";
          };
        };
        docked = {
          eDP-1 = framework // {
            position = "0x0";
          };
          DP-1-3 = dock // {
            position = "1805x0";
          };
        };
        docked-alt = {
          eDP-1 = framework // {
            position = "1080x716";
          };
          DP-4 = portable-second // {
            position = "0x0";
          };
          DP-1-3 = dock // {
            position = "2885x506";
          };
        };
        dorm = {
          eDP-1 = framework // {
            position = "1920x0";
          };
          DP-4 = dorm // {
            position = "0x0";
          };
        };
        dorm-2 = {
          eDP-1 = framework // {
            position = "1920x0";
          };
          DP-3 = dorm // {
            position = "0x0";
          };
        };
      }
    );
}
