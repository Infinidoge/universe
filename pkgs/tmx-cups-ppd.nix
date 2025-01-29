{
  stdenv,
  fetchurl,
  bintools,
  cups,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "tmx-cups-ppd";
  version = "2.0.2.101";

  src = fetchurl {
    url = "https://ftp.epson.com/drivers/pos/tmx-cups-${version}.tar.gz";
    sha256 = "sha256-8WA6Q5z9//UJj20VHOsPA/nCCd50CcaHRVArtmTjeiQ=";
  };

  buildInputs = [
    bintools
    cups
    autoPatchelfHook
  ];

  buildPhase = ''
    ar p filter/tmx-cups_*_amd64.deb data.tar.gz \
      | tar zxf - --wildcards './usr/lib/cups/filter/*'
  '';

  installPhase = ''
    mkdir -p $out/share/cups/model/
    mkdir -p $out/lib/cups/filter/

    cp ppd/*.ppd.gz $out/share/cups/model/
    cp usr/lib/cups/filter/* $out/lib/cups/filter/
  '';

  meta = {
    homepage = "https://epson.com/Support/Point-of-Sale/Thermal-Printers/Epson-TM-m30-Series/s/SPT_C31CE95011";
    description = "CUPS PPD files and filters for EPSON tmx thermal printers";
  };
}
