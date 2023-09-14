inputs: final: prev:
let
  mkPkgs = channel: channel.legacyPackages.${final.system};

  latest = mkPkgs inputs.latest;
  fork = mkPkgs inputs.fork;
  stable = mkPkgs inputs.stable;
in
{
  inherit latest fork stable;

  inherit (latest)
    ;

  inherit (fork)
    ;

  inherit (stable)
    ;

  # https://github.com/NixOS/nixpkgs/issues/252769
  # https://github.com/NixOS/nixpkgs/issues/252320#issuecomment-1706262385
  python3 = prev.python3.override {
    packageOverrides = pythonFinal: pythonPrev: {
      qtile = pythonPrev.qtile.overrideAttrs (oldAttrs: {
        version = "unstable-2023-09-08";
        src = oldAttrs.src.override {
          rev = "133c4119e34635296c1db62346325152f89d6df9";
          hash = "sha256-JtPN0FMRZMc89AzQfe0JiB9OMR+tmMq+pLye5nAOQ7Y=";
        };

        propagatedBuildInputs =
          let
            xcffib = pythonFinal.xcffib.overrideAttrs (oldAttrs: rec {
              version = "1.5.0";
              patches = [ ];
              src = oldAttrs.src.override {
                inherit version;
                hash = "sha256-qVyUZfL5e0/O3mBr0eCEB6Mt9xy3YP1Xv+U2d9tpGsw=";
              };
            });
          in
          with final; with pythonFinal; [
            (pywlroots.overridePythonAttrs (oldAttrs: rec {
              version = "0.16.4";
              src = oldAttrs.src.override {
                inherit version;
                hash = "sha256-+1PILk14XoA/dINfoOQeeMSGBrfYX3pLA6eNdwtJkZE=";
              };
              buildInputs = [ wlroots_0_16 ] ++ lib.remove wlroots oldAttrs.buildInputs;
            }))
            xcffib
            (cairocffi.override { withXcffib = true; inherit xcffib; })
            iwlib
          ] ++ lib.remove
            (cairocffi.override { withXcffib = true; })
            (lib.remove pywlroots oldAttrs.propagatedBuildInputs);

        buildInputs = with final; [
          wlroots_0_16
          libdrm
        ] ++ lib.remove wlroots oldAttrs.buildInputs;

        postPatch = with final; oldAttrs.postPatch + ''
          substituteInPlace libqtile/backend/wayland/cffi/cairo_buffer.py \
            --replace drm_fourcc.h libdrm/drm_fourcc.h

          substituteInPlace libqtile/backend/wayland/cffi/build.py \
            --replace /usr/include/pixman-1 ${pixman.outPath}/include \
            --replace /usr/include/libdrm ${libdrm.dev.outPath}/include/libdrm
        '';
      });
    };
  };
}
